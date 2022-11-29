//
//  GroupListViewContoller.swift
//  WidgetBus
//
//  Created by Shin yongjun on 2022/11/11.
//

import CoreData
import UIKit

struct GroupListArray: Decodable {
    let groupName: String
}
final class GroupListViewContoller: UIViewController {
    let initMain = true
    var groupName = ["출근길", "퇴근길", "백화점으로", "어디로", "시장으로", "제주도로", "어디로가죠", "저도 모르는 곳으로 가요"]

    // CoreData 컨트롤러
    var dataController: DataController!

    // Group Array
    var coreDataGroups = [Group]()

    // 그룹 리스트 테이블
    private lazy var groupListView: UITableView = {
        let groupList = UITableView(frame: .zero, style: .plain)
        groupList.translatesAutoresizingMaskIntoConstraints = false
        groupList.separatorStyle = .none
        groupList.rowHeight = 100
        groupList.showsVerticalScrollIndicator = false
        groupList.register(GroupTableViewCell.self, forCellReuseIdentifier: GroupTableViewCell.identifier)
        groupList.register(
            AddGroupTableViewCell.self,
                           forCellReuseIdentifier: AddGroupTableViewCell.identifier)
        return groupList
    }()

    // 초기 문구
    private lazy var mainLabel: UILabel = {
        let mainLabel = UILabel()
        mainLabel.text = "그룹을 \n추가해주세요."
        mainLabel.numberOfLines = 2
        mainLabel.textAlignment = .center
        mainLabel.font = UIFont.systemFont(ofSize: 20, weight: .light)

        return mainLabel
    }()

    // 메인 그룹 추가 버튼
    private lazy var addButton: UIButton = {
        let addButton = UIButton()

        addButton.setTitle("+", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.backgroundColor = .duduDeepBlue
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 50)
        addButton.layer.opacity = 0.4
        addButton.layer.cornerRadius = 15
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOpacity = 1.0
        addButton.layer.shadowOffset = CGSize.zero
        addButton.layer.shadowRadius = 2

        return addButton
    }()

    func getGroupsFromCoreData() {
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createDate", ascending: false)

        fetchRequest.sortDescriptors = [sortDescriptor]

        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            coreDataGroups = result
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        getGroupsFromCoreData()

        groupListView.delegate = self
        groupListView.dataSource = self

        setupNavigationController()

        if initMain == true {
            setupMainView()
        } else {
            setupTableView()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.view.backgroundColor = .white
    }
}

private extension GroupListViewContoller {
    func setupNavigationController() {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.systemGray2
        titleLabel.text = "뜌벅초"
        titleLabel.font = UIFont.systemFont(ofSize: 42, weight: .bold)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)

        let button = UIButton(type: .system)
        let buttonImage = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        button.setImage(UIImage(systemName: "gearshape", withConfiguration: buttonImage), for: .normal)
        button.addTarget(self, action: #selector(pressButton(_:)), for: .touchUpInside)
        button.tintColor = .black
        let barButtonItem = UIBarButtonItem(customView: button)
        barButtonItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        barButtonItem.customView?.heightAnchor.constraint(equalToConstant: 30).isActive = true
        barButtonItem.customView?.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.navigationItem.rightBarButtonItem = barButtonItem
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .white
    }

    @objc func pressButton(_ sender: UIBarButtonItem) {
        let settingView = SettingViewController()
        self.navigationController?.pushViewController(settingView, animated: true)
    }
}

private extension GroupListViewContoller {
    func setupMainView() {
        self.view.addSubview(mainLabel)

        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -120).isActive = true

        self.view.addSubview(addButton)

        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 70).isActive = true
        addButton.centerXAnchor.constraint(equalTo: mainLabel.centerXAnchor).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 361).isActive = true
        addButton.addTarget(self, action: #selector(btnAddGroupList(_:)), for: .touchUpInside)
    }

    // 데이터 없을 때, 여기 추가.
    @objc func btnAddGroupList(_ sender: UIButton) {
        let addGroupListNameView = AddGroupListNameViewController()
        addGroupListNameView.dataController = dataController

        self.navigationController?.pushViewController(addGroupListNameView, animated: true)
    }
}
private extension GroupListViewContoller {
    func setupTableView() {

        self.view.addSubview(groupListView)
        groupListView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        groupListView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        groupListView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        groupListView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true

    }
}

extension GroupListViewContoller: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 데이터 있을 때, 여기 추가.
        if indexPath.row == groupName.count {
            let addGroupListNameView = AddGroupListNameViewController()
            addGroupListNameView.dataController = dataController

            self.navigationController?.pushViewController(addGroupListNameView, animated: true)


        } else {
            let settingView = SettingViewController()
            self.navigationController?.pushViewController(settingView, animated: true)

        }
    }
}

extension GroupListViewContoller: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupName.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == groupName.count {
            // 마지막 섹션
            let cell = groupListView.dequeueReusableCell(
                withIdentifier: AddGroupTableViewCell.identifier,
                for: indexPath) as! AddGroupTableViewCell
            cell.selectionStyle = .none
            return cell
        } else {
            // 기본 섹션
            let cell = groupListView.dequeueReusableCell(
                withIdentifier: GroupTableViewCell.identifier,
                for: indexPath) as! GroupTableViewCell
            cell.selectionStyle = .none
            cell.groupListLabel.text = groupName[indexPath.row]

            return cell
        }
    }
}
