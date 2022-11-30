//
//  AddGroupListNameView.swift
//  WidgetBus
//
//  Created by Shin yongjun on 2022/11/13.
//

import UIKit

final class AddGroupListNameViewController: UIViewController {

    // CoreData Controller
    var dataController: DataController!

    // 바탕 뷰
    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .duduDeepBlue

        return view
    }()

    // 하단 흰색 뷰
    private let bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.backgroundColor = .white

        return view
    }()

    // 상단 설명 라벨
    private let titleLabel: UILabel = {
        let viewLabel = UILabel()
        viewLabel.text = "어떨때 이용하는 \n대중교통인가요?"
        viewLabel.numberOfLines = 2
        viewLabel.textAlignment = .center
        viewLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        viewLabel.textColor = .white
        viewLabel.translatesAutoresizingMaskIntoConstraints = false

        return viewLabel
    }()

    // 상단 인디케이터 이미지
    let indicatorImage: UIImageView = {
        let indicatorImage = UIImageView()
        indicatorImage.image = UIImage(named: "ProgressIndicator.png")
        indicatorImage.translatesAutoresizingMaskIntoConstraints = false

        return indicatorImage
    }()

    // 출발지 입력 텍스트필드
    lazy var groupListTextfield: UITextField = {
        var groupListTextfield = UITextField()
        groupListTextfield.font = UIFont(name: "SFUI-Regular", size: 30)
        groupListTextfield.placeholder = "출발지를 입력해주세요"
        groupListTextfield.tintColor = .black
        groupListTextfield.layer.shadowColor = UIColor.black.cgColor
        groupListTextfield.layer.shadowOpacity = 0.3
        groupListTextfield.translatesAutoresizingMaskIntoConstraints = false
        groupListTextfield.layer.shadowOffset = CGSize(width: 0, height: 2)
        groupListTextfield.layer.shadowRadius = 2
        groupListTextfield.borderStyle = .roundedRect
        groupListTextfield.clearButtonMode = .whileEditing

        return groupListTextfield
    }()

    // 하단 설명 라벨
    private let bottomLabel: UILabel = {
        let viewLabel = UILabel()
        viewLabel.text = "버스로 자주다니는 곳을 등록해 보세요!"
        viewLabel.textAlignment = .center
        viewLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        viewLabel.textColor = .gray
        viewLabel.translatesAutoresizingMaskIntoConstraints = false

        return viewLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.groupListTextfield.delegate = self

        setupNavigationController()
        setupLayout()

    }

    override func viewWillAppear(_ animated: Bool) {
        self.groupListTextfield.becomeFirstResponder()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.groupListTextfield.resignFirstResponder()
    }

    @objc func pressButton(_ sender: UIBarButtonItem) {
        guard let groupName = self.groupListTextfield.text else {
            return
        }

        let newGroup = Group(context: dataController.viewContext)
        newGroup.id = UUID()
        newGroup.name = groupName
        let storyboard = UIStoryboard(name: "SelectStartNodeView", bundle: nil)
        let selectStartNodeViewController =
        storyboard.instantiateViewController(
            withIdentifier: "SelectStartNodeView") as! SelectStartNodeViewController

        selectStartNodeViewController.dataController = dataController
        selectStartNodeViewController.newGroup = newGroup

        self.navigationController?.pushViewController(selectStartNodeViewController, animated: true)
    }
}

private extension AddGroupListNameViewController {
    func setupLayout() {
        self.view.addSubview(backgroundView)
        backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        backgroundView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: backgroundView.widthAnchor).isActive = true

        backgroundView.addSubview(indicatorImage)
        indicatorImage.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 80).isActive = true
        indicatorImage.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor).isActive = true
        indicatorImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        indicatorImage.heightAnchor.constraint(equalToConstant: 30).isActive = true

        backgroundView.addSubview(bottomView)
        bottomView.topAnchor.constraint(equalTo: indicatorImage.topAnchor, constant: 50).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        bottomView.addSubview(groupListTextfield)
        groupListTextfield.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 20)
            .isActive = true
        groupListTextfield.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 15).isActive = true
        groupListTextfield.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -15)
            .isActive = true
        groupListTextfield.heightAnchor.constraint(equalToConstant: 80).isActive = true

        bottomView.addSubview(bottomLabel)
        bottomLabel.topAnchor.constraint(equalTo: groupListTextfield.topAnchor, constant: 100)
            .isActive = true
        bottomLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor).isActive = true
        bottomLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor).isActive = true

    }
}

extension AddGroupListNameViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.groupListTextfield.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
        return true
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String
    ) -> Bool {
        guard groupListTextfield.text!.count < 17 else { return false }
        navigationItem.rightBarButtonItem?.isEnabled = true
        return true
    }
}

private extension AddGroupListNameViewController {
    func setupNavigationController() {
        let button = UIButton(type: .system)
        let barButtonItem = UIBarButtonItem(customView: button)
        barButtonItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        barButtonItem.customView?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        barButtonItem.customView?.widthAnchor.constraint(equalToConstant: 40).isActive = true

        self.navigationItem.rightBarButtonItem = barButtonItem
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.view.backgroundColor = .duduDeepBlue

        let rightButton = UIBarButtonItem(
            title: "다음",
            style: .plain,
            target: self,
            action: #selector(pressButton(_:))
        )

        navigationItem.rightBarButtonItem = rightButton
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
}
