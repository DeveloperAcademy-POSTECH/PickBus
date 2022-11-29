//
//  SelectRouteNumberViewController.swift
//  WidgetBus
//
//  Created by Jaehwa Noh on 2022/11/10.
//

import UIKit

class SelectRouteNumberViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private struct RouteNumberCellStruct: Hashable {
        let routeNumber: String
        let routeType: String
        let routeId: String
    }

//    private var routeNumberInfos = [ArriveInfoResponseArriveInfo]()
    var selectedIndex = IndexPath(row: -1, section: 0)
    @IBOutlet weak var routeNumberTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let rightButton = UIBarButtonItem(
            title: "다음",
            style: .plain,
            target: self,
            action: #selector(pressButton(_:))
        )
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.rightBarButtonItem?.isEnabled = true

        newBus = Bus(context: dataController.viewContext)
        newBus.startNodeId = newNode.nodeId
        newBus.startNodeName = newNode.nodeNm
//        navigationItem.rightBarButtonItem?.tintColor = .white

//        super.setTitleAndIndicator(titleText: "test", indicatorStep:.stepThree)

//        super.bottomView.addSubview(routeNumberTableView)
//        routeNumberTableView.translatesAutoresizingMaskIntoConstraints = false
//        routeNumberTableView.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        routeNumberTableView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor).isActive = true
//        routeNumberTableView.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true

        print("hello: \(newNode.cityCode!), \(newNode.nodeId!)")
        self.navigationItem.title = "\(newNode.nodeNm!)"
        BusClient.getAllRoutesFromNode(
            city: newNode.cityCode!,
            nodeId: newNode.nodeId!,
            completion: handleRequestAllRoutesInfoResponse(response:error:))
    }
//    여기 변수 타입 변경.

    @objc func pressButton(_ sender: UIBarButtonItem) {

        let selectArrivalviewController = SelectArrivalViewController()

        selectArrivalviewController.newBus = newBus
        selectArrivalviewController.dataController = dataController
        selectArrivalviewController.newNode = newNode
        selectArrivalviewController.newGroup = newGroup

        self.navigationController?.pushViewController(selectArrivalviewController, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteNumberCell", for: indexPath)
        var cellContent = cell.defaultContentConfiguration()
        if routeNumberInfos.isEmpty {
            cellContent.text = "불러오는 중입니다."

        } else {
            let cellData = routeNumberInfos[indexPath.row]
            cellContent.text = "\(cellData.routeno) 번"
            cellContent.secondaryText = cellData.routetp
        }
        if selectedIndex == indexPath {
            cell.backgroundColor = UIColor(named: "duduBlue")
        } else {
            cell.backgroundColor = UIColor.clear
        }
        cell.selectionStyle = .none
        cell.contentConfiguration = cellContent

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        selectedIndex = indexPath
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("run \(routeNumberInfos)")
        if routeNumberInfos.isEmpty {
            return 3
        } else {
            return routeNumberInfos.count
        }
    }

    func handleRequestAllRoutesInfoResponse(response: [AllRoutesFromNodeInfo], error: Error?) {
        routeNumberCellInfos = response.map { res in
            RouteNumberCellStruct(
                routeNumber: res.routeno.stringValue,
                routeType: res.routetp,
                routeId: res.routeid)
        }
        routeNumberCellInfos = Array(Set(routeNumberCellInfos))
        routeNumberCellInfos.sort {
            $0.routeNumber < $1.routeNumber
        }
        routeNumberTableView.reloadData()
        for test in response {
            print(test)
        }
        print("response")
        print("error")
        print(error?.localizedDescription ?? "")
    }
}
