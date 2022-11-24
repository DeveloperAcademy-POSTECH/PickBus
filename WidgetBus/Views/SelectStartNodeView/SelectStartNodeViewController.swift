//
//  SelectStartNodeViewController.swift
//  WidgetBus
//
//  Created by 김민재 on 2022/11/15.
//

import UIKit

final class SelectStartNodeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var busNodeSearchTextField: UITextField!

    // CoreData Controller
    var dataController: DataController!
    var newGroup: Group!

    @IBAction private func didKeyboardEndOnExit(_ sender: Any) {
        // 키보드 완료 버튼 눌렀을 때 busNodeSearchTextField.text를 이용해 API 호출
        workItem?.cancel()
        if cityCodeDictionary.isEmpty {
            getCityCode(isInit: false)
        } else {
            startSearch()
        }
    }

    @IBAction private func editingTextFieldChanged(_ sender: Any) {
        stop = true
        if repeatCount == cityCodeDictionary.keys.count {
            clearNetworkSessionTask()
        }
    }

    private var selectedTableViewCellIndexPath: IndexPath?

    // load task
    private var loadTasks = [URLSessionDataTask]()
    // work item
    private var workItem: DispatchWorkItem?
    private var stop: Bool = false
    private var repeatCount: Int = 1

    // 도시코드 딕션어리
    private var cityCodeDictionary = [Int: String]()

    var nodeName: [String] = [
        "정류장1", "정류장2", "정류장3", "정류장4", "정류장5", "정류장6", "정류장7", "정류장8", "정류장9", "정류장10",
        "정류장11", "정류장12", "정류장13", "정류장14", "정류장15", "정류장16", "정류장17", "정류장18", "정류장19", "정류장20"
    ]
    var nodeDirection: [String] = [
        "정류장2방면", "정류장3방면", "정류장4방면", "정류장5방면", "정류장6방면",
        "정류장7방면", "정류장8방면", "정류장9방면", "정류장10방면", "정류장11방면",
        "정류장12방면", "정류장13방면", "정류장14방면", "정류장15방면", "정류장16방면",
        "정류장17방면", "정류장18방면", "정류장19방면", "정류장20방면", "정류장1방면"
    ]
    var nodeDistance: [String] = [
        "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
        "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // 텍스트 필드 레이아웃 설정
        busNodeSearchTextField.layer.cornerRadius = 15
        busNodeSearchTextField.layer.borderWidth = 2
        busNodeSearchTextField.layer.borderColor = UIColor.duduDeepBlue?.cgColor
        busNodeSearchTextField.addLeftPadding()

        // 도시 코드 가져오기
        getCityCode()

        settingDefaultTableView()
        addDefaultKeyboardObserver()
    }

    override func viewDidDisappear(_ animated: Bool) {
        removeDefaultKeyboardObserver()
    }

    func getCityCode(isInit: Bool = true) {
        if isInit {
            BusClient.getCityCodeList(completion: handleRequestCityCodeResponse(response:error:))
        } else {
            BusClient.getCityCodeList(completion: handleRequestCityCodeResponseSearch(response:error:))
        }
    }

    // MARK: 테이블
    func settingDefaultTableView() {
        tableView.register(
            SelectStartNodeTableViewCell.nib(),
            forCellReuseIdentifier: SelectStartNodeTableViewCell.identifier
        )
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nodeName.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SelectStartNodeTableViewCell.identifier,
            for: indexPath
        ) as? SelectStartNodeTableViewCell else {
            return UITableViewCell()
        }

        cell.nodeName.text = nodeName[indexPath.row]
        cell.nodeDirection.text = nodeDirection[indexPath.row]
        cell.nodeDistance.text = nodeDistance[indexPath.row]
        cell.settingData(isClicked: selectedTableViewCellIndexPath == indexPath)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedTableViewCellIndexPath == indexPath {
            selectedTableViewCellIndexPath = nil
        } else {
            // selectedTableViewCellIndexPath가 prevSelectedTableViewCell로 이동된 후 실행되어야 함
            if let prevSelectedTableViewCell = selectedTableViewCellIndexPath {
                selectedTableViewCellIndexPath = indexPath
                tableView.reloadRows(at: [prevSelectedTableViewCell], with: .automatic)
            } else {
                selectedTableViewCellIndexPath = indexPath
            }
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    // MARK: 키보드
    private func addDefaultKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }

    private func removeDefaultKeyboardObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }

    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame: NSValue =
                notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        UIView.animate(withDuration: 1) {
            self.view.frame.origin.y -= keyboardHeight
        }
    }

    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0
    }

    // MARK: 검색

    // 검색 시작
    func startSearch() {
        let nodeName: String?
        let nodeNumber: String?
        // 번호 검색인지 이름 검색인지 확인.
        if Int(self.busNodeSearchTextField.text ?? "") == nil {
            nodeNumber = nil
            nodeName = self.busNodeSearchTextField.text ?? ""
        } else {
            nodeNumber = self.busNodeSearchTextField.text ?? ""
            nodeName = nil
        }

        workItem = DispatchWorkItem {
            self.repeatCount = 0
            self.loadTasks = [URLSessionDataTask]()

            for mCityCode in self.cityCodeDictionary.keys {

                if self.stop {
                    self.clearNetworkSessionTask()
                    break
                }
                self.repeatCount += 1
                let task = BusClient.searchNodeList(
                    city: String(mCityCode),
                    nodeName: nodeName,
                    nodeNumber: nodeNumber,
                    completion: self.handleRequestSearchNodeResponse(cityCode:response:error:))

                self.loadTasks.append(task)

                if self.repeatCount % 25 == 0 && self.repeatCount > 0 {
                    sleep(1)
                }
            }
        }
        if let workItem = workItem {
            stop = false
            DispatchQueue.global(qos: .userInitiated).async(execute: workItem)

        }
    }

    // 도시 코드 가져오는 네트워크 완료된 다음 실행되는 콜백(초반)
    func handleRequestCityCodeResponse(response: [CityCodeInfo], error: Error?) {
        guard error == nil else {
            return
        }
        if !response.isEmpty {
            cityCodeDictionary = makeCityCodeDictionary(cityCodeArray: response)
        }
    }

    // 도시 코드 가져오는 네트워크 완료된 다음 실행되는 콜백(검색)
    func handleRequestCityCodeResponseSearch(response: [CityCodeInfo], error: Error?) {
        guard error == nil else {
            return
        }
        if !response.isEmpty {
            cityCodeDictionary = makeCityCodeDictionary(cityCodeArray: response)
            startSearch()
        }
    }

    // 검색 후, 실행되는 콜백
    func handleRequestSearchNodeResponse(cityCode: Int?, response: [SearchNodeInfo], error: Error?) {
        guard error == nil else {
            return
        }

        // API 응답 결과
        if !response.isEmpty {
            print(cityCode!)
            print(cityCodeDictionary[cityCode!] ?? "Nil_")
            print(response)
        }
    }

    // 네트워크 작동 취소
    func clearNetworkSessionTask() {
        for loadTask in self.loadTasks {
            if loadTask.state == .running || loadTask.state == .suspended {
                loadTask.cancel()
            }

        }
        self.loadTasks = [URLSessionDataTask]()
        repeatCount = 0
    }

    // 배열을 딕션어리로 변경하는 함수
    func makeCityCodeDictionary(cityCodeArray: [CityCodeInfo]) -> [Int: String] {
        var tmpCityCodeDictionary = [Int: String]()
        for cityCode in cityCodeArray {
            if tmpCityCodeDictionary.keys.contains(cityCode.citycode) {
                continue
            } else {
                tmpCityCodeDictionary[cityCode.citycode] = cityCode.cityname
            }
        }
        return tmpCityCodeDictionary
    }
}
