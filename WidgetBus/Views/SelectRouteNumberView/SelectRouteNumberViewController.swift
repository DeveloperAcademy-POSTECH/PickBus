//
//  SelectRouteNumberViewController.swift
//  WidgetBus
//
//  Created by Jaehwa Noh on 2022/11/10.
//

import UIKit

class SelectRouteNumberViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var routeNumberInfos = [ArriveInfoResponseArriveInfo]()
    var selectedIndex = IndexPath(row: -1, section: 0)
    @IBOutlet weak var routeNumberTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "송강전통시장"
        BusClient.getArriveList(completion: handleRequestArriveInfoResponse(response:error:))
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

    func handleRequestArriveInfoResponse(response: [ArriveInfoResponseArriveInfo], error: Error?) {
        routeNumberInfos = response
        routeNumberTableView.reloadData()
        for test in response {
            print(test)
        }
        print("response")
        print("error")
        print(error?.localizedDescription ?? "")
    }
}
