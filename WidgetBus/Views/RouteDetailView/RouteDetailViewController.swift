//
//  RouteDetailViewController.swift
//  WidgetBus
//
//  Created by 김혜수 on 2022/11/12.
//

import UIKit
import CoreLocation

enum BoardingStatus {
    case onBoard
    case getOff
}

struct RouteModel {
    let startNodeId: String
    let endNodeId: String
}

class RouteDetailViewController: UIViewController {

    @IBOutlet weak var busNumberLabel: UILabel!
    @IBOutlet weak var startStationLabel: UILabel!
    @IBOutlet weak var endStationLabel: UILabel!
    @IBOutlet weak var busTimeInfoLabel: UILabel!

    @IBOutlet weak var routeView: UIView!
    @IBOutlet weak var routeDetailTableView: UITableView!

    @IBOutlet weak var boardingStateButton: UIButton!

    var boardingStatus: BoardingStatus = .onBoard

    let route: RouteModel = RouteModel(startNodeId: "DJB8001780", endNodeId: "DJB8003057")

    // Jedi
    // 코어데이터에서 가져오는 정보들 (예정)
    // 노선 ID
    var routeId: String = "DJB30300004"
    // 정류장 ID
    var nodeId: String = "DJB8001793"
    // 도시 코드
    var cityCode: Int = 25
    // 버스 정류장들
    private var nodeList = [RouteNodesInfo]()
    // 버스 위치
    private var busLocationList = [BusLocationsInfo]()
    private var busLocationListIndex = 0
    private var busLocationIndexPath: [Int] = []

    // 새로고침
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)

        return refreshControl
    }()

    @objc func fetchData() {

    }

    @IBAction func tapBoardingStateButton(_ sender: UIButton) {
        switch self.boardingStatus {
        case .onBoard:
            self.boardingStatus = .getOff
            self.boardingStateButton.isSelected = true

            let moveIndex = IndexPath(row: 9, section: 0)
            self.routeDetailTableView.scrollToRow(at: moveIndex, at: .middle, animated: true)

        case .getOff:
            self.boardingStatus = .onBoard
            self.boardingStateButton.isSelected = false
        }
    }

    let retryButton = UIButton(frame: CGRect(x: 318, y: 707, width: 55, height: 55))

    override func viewDidLoad() {
        super.viewDidLoad()
        // 네트워크 전송.
        callNetworkFunction()

        routeView.clipsToBounds = true
        routeView.layer.cornerRadius = 30
        routeView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)

        self.view.backgroundColor = .duduDeepBlue
        self.routeDetailTableView.dataSource = self
        self.routeDetailTableView.delegate = self
        busNumberLabel.text = "1000"

        retryButton.backgroundColor = .blue
        retryButton.layer.cornerRadius = 0.5 * retryButton.bounds.width
        retryButton.setImage(#imageLiteral(resourceName: "retry"), for: .normal)
        retryButton.backgroundColor = .duduDeepBlue
        self.view.addSubview(retryButton)
        self.configureBoardingTapButton()
    }

    // 네트워크 연결 부르는 함수
    func callNetworkFunction() {
        BusClient.getNodesListBody(
            city: String(cityCode),
            routeId: routeId,
            completion: handleRequestNodesTotalNumberResponse(response:error:))

        BusClient.getRouteInformation(
            city: String(cityCode),
            routeId: routeId,
            completion: handleRequestRouteInformation(response:error:))

        BusClient.getLocationsOnRoute(
            city: String(cityCode),
            routeId: routeId,
            completion: handleRequestLocationsOnRouteResponse(response:error:))

        BusClient.getSpecificArrive(
            city: String(cityCode),
            routeId: routeId,
            nodeId: nodeId,
            completion: handleRequestSpecificArriveInfoResponse(response:error:))
    }

    func configureBoardingTapButton() {

        let boardText = "탑승"
        let boardAttribute = NSMutableAttributedString(string: boardText)
        let font = UIFont(name: "Helvetica-Bold", size: 40)
        boardAttribute.addAttribute(
            NSAttributedString.Key.font,
            value: font as Any,
            range: NSRange(location: 0, length: boardText.count)
        )
        self.boardingStateButton.setAttributedTitle(boardAttribute, for: .normal)

        let getOffText = "탑승취소"
        let getOffAttribute = NSMutableAttributedString(string: getOffText)
        getOffAttribute.addAttribute(
            NSAttributedString.Key.font,
            value: font as Any,
            range: NSRange(location: 0, length: getOffText.count)
        )
        self.boardingStateButton.setAttributedTitle(getOffAttribute, for: .selected)
    }

    // 전체 갯수 확인하는 네트워크 결과 받으면 실행되는 콜백.
    func handleRequestNodesTotalNumberResponse(response: RouteNodesResponseBody?, error: Error?) {
        if let response = response {
            let iterater: Int = (response.totalCount / response.numOfRows) + 1
            for index in 1...iterater {
                BusClient.getNodeList(
                    city: String(cityCode),
                    routeId: routeId,
                    pageNo: String(index),
                    completion: handleRequestNodesListResponse(response:error:))
            }
        }

        //        print("error")
        //        print(error?.localizedDescription ?? "")
    }

    // 버스 정류장 정보 받아오는 네트워크 결과 받으면 실행되는 콜백.
    func handleRequestNodesListResponse(response: [RouteNodesInfo], error: Error?) {
        guard !response.isEmpty else {
            //        print("error")
            //        print(error?.localizedDescription ?? "")
            return
        }

        nodeList += response

        nodeList.sort { $0.nodeord < $1.nodeord }

        print("Node List: \(nodeList.count)")
        routeDetailTableView.reloadData()

    }

    // 노선 정보 받아오는 네트워크 결과 받으면 실행되는 콜백.
    func handleRequestRouteInformation(response: RouteInformationInfo?, error: Error?) {
        // 여기 버스 노선 정보 첫차, 막차 등.
        guard let response = response else {
            //        print("error")
            //        print(error?.localizedDescription ?? "")
            return
        }

        var startTime: String = response.startvehicletime
        var endTime: String = String(response.endvehicletime)
        var intervalTime: Int
        let today = Date()
        let weekday = Calendar.current.component(.weekday, from: today)

        switch weekday {
        case 1:
            intervalTime = response.intervalsuntime
        case 7:
            intervalTime = response.intervalsattime
        default:
            intervalTime = response.intervaltime
        }

        startTime.insert(":", at: startTime.index(startTime.startIndex, offsetBy: 2))
        endTime.insert(":", at: endTime.index(endTime.startIndex, offsetBy: 2))

        busTimeInfoLabel.text = "\(startTime) ~ \(endTime) 배차간격 \(intervalTime)분"
//        print("RouteInformation: \(response)")
    }

    // 버스 위치 받아오는 네트워크 결과 받으면 실행되는 콜백.
    func handleRequestLocationsOnRouteResponse(response: [BusLocationsInfo], error: Error?) {
        // 여기 버스 위치들 나타남
        guard !response.isEmpty else {
            //        print("error")
            //        print(error?.localizedDescription ?? "")
            return
        }
        busLocationList += response
        busLocationList.sort { $0.nodeord < $1.nodeord }
        print("Locations: \(response)")
        routeDetailTableView.reloadData()
    }

    // 정류장에 오는 특정 노선에 대한 도착 정보만 받는 네트워크 결과 받으면 실행되는 콜백.
    func handleRequestSpecificArriveInfoResponse(response: SpecificArriveInfo?, error: Error?) {
        // 여기 특정 노선에 대한 도착 정보 표현 됨.
        guard let response = response else {
            //        print(error)
            //        print(error?.localizedDescription)
            return
        }
        print("Response: \(response)")
    }
}

extension RouteDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nodeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "routeDetailCell",
            for: indexPath) as! RouteDetailTableViewCell
        if nodeList.isEmpty {
            cell.busStationLabel.text = "불러오는 중입니다."
        } else {
            let cellData = nodeList[indexPath.row]
            cell.busStationLabel.text = "\(cellData.nodenm)"

            cell.highlightView.layer.cornerRadius = 15

            // 출발지 도착지 표시
            if(route.startNodeId == cellData.nodeid) {
                cell.highlightView.isHidden = false
                cell.highlightView.backgroundColor = .duduRed
                cell.highlightLabel.text = "출발"
            } else if(route.endNodeId == cellData.nodeid) {
                self.view.sendSubviewToBack(self.view)
                cell.highlightView.isHidden = false
                cell.highlightView.backgroundColor = .duduBlue
                cell.highlightLabel.text = "도착"
            } else {
                cell.busTimeLabel2.text = "10분"
                cell.highlightView.isHidden = true
            }

            cell.busView2.isHidden = true
            if(busLocationList.isEmpty) {
                print("busLocationList 불러오는 중")
            } else {
                if(busLocationList[busLocationListIndex].nodeord == cellData.nodeord
                   && busLocationListIndex + 1 < busLocationList.count) {
                    busLocationListIndex += 1
                    busLocationIndexPath.append(indexPath.row)
                }

                if(busLocationIndexPath.contains(indexPath.row)) {
                    cell.busView2.isHidden = false
                } else {
                    cell.busView2.isHidden = true
                }
            }
            //            if(cellData.nodeord > route.startNodeId && cellData.nodeord < route.endNodeId) {
            //                cell.routeLineView.backgroundColor = .duduDeepBlue
            //            } else {
            //                cell.routeLineView.backgroundColor = .duduGray
            //            }

            if(indexPath.row + 1 < nodeList.count
               && cellData.updowncd != nodeList[indexPath.row + 1].updowncd) {
                cell.routePointImageView.image = UIImage(systemName: "eraser")
            } else {
                cell.routePointImageView.image = UIImage(systemName: "chevron.down.circle")
            }

        }
        cell.routeLineView.backgroundColor = .duduGray
        cell.busTimeLabel.layer.masksToBounds = true
        cell.busTimeLabel.layer.cornerRadius = 6.5
        cell.busView.isHidden = true
        cell.busTimeLabel2.layer.masksToBounds = true
        cell.busTimeLabel2.layer.cornerRadius = 6.5

        //        cell.busImageView2.image = UIImage(named: "bus")

        //        let endNode = nodeList.count - 1
        //        let index = indexPath.row
        //        if index == endNode {
        //            cell.routeLineView.isHidden = true
        //            cell.busView2.isHidden = true
        //        } else {
        //            cell.routeLineView.isHidden = false
        //            cell.busView2.isHidden = false
        //        }

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}

extension RouteDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
}
