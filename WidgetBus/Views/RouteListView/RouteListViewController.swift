//
//  RouteListViewController.swift
//  WidgetBus
//
//  Created by KoJeongseok on 2022/11/10.
//

import UIKit

class RouteListViewController: UIViewController {

    // 더미 데이터
    var busStops = BusData.busStops

    // 셀 높이
    let routeHeaderCellHeight: CGFloat = 35
    let routeCellHeight: CGFloat = 50
    let addRouteCellHeight: CGFloat = 78

    // 루트테이블 뷰
    private let routeTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.showsVerticalScrollIndicator = false
        table.sectionHeaderTopPadding = 25
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        // 그림자
        table.layer.masksToBounds = false
        table.layer.shadowColor = UIColor.black.cgColor
        table.layer.shadowOpacity = 0.2
        table.layer.shadowRadius = 10
        table.layer.shadowOffset = .init(width: 0, height: 2)

        // 테이블 뷰 요소 등록 - 타이틀, 정류장, 루트, 루트추가
        table.register(TitleHeader.self, forHeaderFooterViewReuseIdentifier: TitleHeader.identifier)
        table.register(BusStopCell.self, forCellReuseIdentifier: BusStopCell.identifier)
        table.register(RouteCell.self, forCellReuseIdentifier: RouteCell.identifier)
        table.register(AddRouteCell.self, forCellReuseIdentifier: AddRouteCell.identifier)

        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .duduDeepBlue

        setupNavigationBar()
        setupLayout()
        setupConstraints()
        routeTableView.reloadData()
        routeTableView.delegate = self
        routeTableView.dataSource = self
    }

    private func setupNavigationBar() {
        // 타이틀 설정
        title = "포스텍"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.clear]

        // back 버튼
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(pressedBackButton(_ :))
        )
        // 편집 버튼
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "편집",
            style: .plain,
            target: self,
            action: #selector(pressedEditButton(_ :))
        )
        navigationController?.navigationBar.tintColor = .white
    }

    private func setupLayout() {
        self.view.addSubview(routeTableView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([

            // 루트테이블뷰
            routeTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            routeTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            routeTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            routeTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }

    // 뒤로가기
    @objc private func pressedBackButton(_ sender: UIButton!) {
        navigationController?.popViewController(animated: true)
    }

    // 편집하기
    @objc private func pressedEditButton(_ sender: UIButton!) {
        if self.routeTableView.isEditing {
            navigationItem.rightBarButtonItem?.title = "편집"
            self.routeTableView.setEditing(false, animated: true)
            self.routeTableView.reloadData()
        } else {
            navigationItem.rightBarButtonItem?.title = "완료"
            self.routeTableView.setEditing(true, animated: true)
        }
    }
}

// MARK: - UITableViewDelegate
extension RouteListViewController: UITableViewDelegate {

    // 섹션, 루트 삭제 기능
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if busStops[indexPath.section].routes.count == 1 {
            // 섹션 제거
            busStops.remove(at: indexPath.section)
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
        } else {
            // 루트 제거
            busStops[indexPath.section].routes.remove(at: indexPath.row - 1)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    // 첫번째 셀은 삭제 불가능 - 정류장 이름 셀, 루트 차가하기 셀
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        indexPath.row == 0 ? false : true
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if routeTableView.contentOffset.y > -40 {
            self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            self.title = "포스텍"
        } else {
            self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.clear]
            self.title = .none
        }
    }
}

// MARK: - UITableViewDataSource
extension RouteListViewController: UITableViewDataSource {

    // 헤더
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: TitleHeader.identifier) as! TitleHeader
        header.busStopLabel.text = busStops[section].name
        return header
    }

    // 헤더 높이
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 50 : 0
    }

    // 섹션 수
    func numberOfSections(in tableView: UITableView) -> Int {
        busStops.count + 1
    }

    // 셀 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == busStops.count ? 1 : busStops[section].routes.count + 1
    }

    // 셀 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.section == busStops.count ?
        addRouteCellHeight : indexPath.row == 0 ?
        routeHeaderCellHeight : routeCellHeight
    }

    // 셀 정의 - 마지막 섹션이면 루트 추가 셀 적용 / 기본 섹션이면 루트 셀 적용
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == busStops.count {
            // 마지막 섹션
            let cell = tableView.dequeueReusableCell(
                withIdentifier: AddRouteCell.identifier,
                for: indexPath) as! AddRouteCell
            return cell
        } else {
            // 기본 섹션
            if indexPath.row == 0 {
                // 헤더 셀
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: BusStopCell.identifier,
                    for: indexPath) as! BusStopCell
                cell.busStopLabel.text = busStops[indexPath.section].name
                cell.selectionStyle = .none
                return cell
            } else {
                // 기본 셀
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: RouteCell.identifier,
                    for: indexPath) as! RouteCell
                let route = busStops[indexPath.section].routes[indexPath.row - 1]
                cell.selectionStyle = .none
                cell.setCell(
                    busNumber: route.busNumber,
                    busRemainingTime: route.busRemainingTime,
                    nextBusRemainingTime: route.nextBusRemainingTimeLabel)
                return cell
            }
        }
    }
}
