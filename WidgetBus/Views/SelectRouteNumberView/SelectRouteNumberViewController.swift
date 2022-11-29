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
        let nodeId: String
        let routeId: String
        let nodeName: String
    }

//    private var routeNumberInfos = [ArriveInfoResponseArriveInfo]()
    var selectedIndex = IndexPath(row: -1, section: 0)

    var dataController: DataController!
    var newNode: Node!
    var newGroup: Group!
    private var newBus: Bus!
    private var routeNumberCellInfos = [RouteNumberCellStruct]()

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

        print("hello: \(newNode.cityCode!), \(newNode.nodeId!)")
        self.navigationItem.title = "\(newNode.nodeNm!)"
        BusClient.getArriveList(
            city: newNode.cityCode!,
            nodeId: newNode.nodeId!,
            completion: handleRequestArriveInfoResponse(response:error:))
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
        if routeNumberCellInfos.isEmpty {
            cellContent.text = "불러오는 중입니다."

        } else {
            let cellData = routeNumberCellInfos[indexPath.row]
            cellContent.text = "\(cellData.routeNumber) 번"
            cellContent.secondaryText = cellData.routeType

            if selectedIndex == indexPath {
                newBus.routeId = cellData.routeId
                newBus.routeNo = cellData.routeNumber
                cell.backgroundColor = UIColor(named: "duduBlue")
            } else {
                cell.backgroundColor = UIColor.clear
            }
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
        print("run \(routeNumberCellInfos)")
        if routeNumberCellInfos.isEmpty {
            return 3
        } else {
            return routeNumberCellInfos.count
        }
    }

    func handleRequestArriveInfoResponse(response: [ArriveInfoResponseArriveInfo], error: Error?) {
        routeNumberCellInfos = response.map { res in
            RouteNumberCellStruct(
                routeNumber: res.routeno.stringValue,
                routeType: res.routetp,
                nodeId: res.nodeid,
                routeId: res.routeid,
                nodeName: res.nodenm)
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
