//
//  SecondViewController.swift
//  WidgetBus
//
//  Created by Shin yongjun on 2022/11/13.
//

import UIKit
import UserNotifications

final class SettingViewController: UIViewController, UNUserNotificationCenterDelegate {

    private lazy var notiLabel: UILabel = {
        let label = UILabel()
        label.text = "알림을 설정해주세요."
        label.font = UIFont.systemFont(ofSize: 30, weight: .semibold)

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var notiDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "앱의 알림을 받으려면 iOS설정에서 알림을 켜주세요."
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var notiButton: UIButton = {
        let button = UIButton()
        button.tintColor = .duduDeepBlue
        button.setTitle("설정으로", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .duduDeepBlue
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor

        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tapButton(sender:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationController()

        // 사용자 권한 받기
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound],
            completionHandler: {didAllow, error  in
            print(didAllow)
            print(error as Any)
        })
        UNUserNotificationCenter.current().delegate = self
        setupLayout()
    }

    @objc func tapButton(sender: UIButton) {
        if let appSettings = NSURL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettings as URL)
        }
    }
}

private extension SettingViewController {
    func setupNavigationController() {
        let button = UIButton(type: .system)
        let barButtonItem = UIBarButtonItem(customView: button)
        barButtonItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        barButtonItem.customView?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        barButtonItem.customView?.widthAnchor.constraint(equalToConstant: 40).isActive = true

        self.navigationItem.rightBarButtonItem = barButtonItem
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
    }
}

private extension SettingViewController {
    func setupLayout() {
        view.addSubview(notiLabel)
        notiLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        notiLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true

        view.addSubview(notiDetailLabel)
        notiDetailLabel.topAnchor.constraint(equalTo: notiLabel.topAnchor, constant: 35).isActive = true
        notiDetailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22).isActive = true

        view.addSubview(notiButton)
        notiButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        notiButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        notiButton.topAnchor.constraint(equalTo: notiLabel.topAnchor, constant: 65).isActive = true
        notiButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80).isActive = true
    }
}
