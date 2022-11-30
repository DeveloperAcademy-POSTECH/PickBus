//
//  SecondViewController.swift
//  WidgetBus
//
//  Created by Shin yongjun on 2022/11/13.
//

import UIKit
import UserNotifications

final class SettingViewController: UIViewController, UNUserNotificationCenterDelegate {

    let notiLabel: UILabel = {
        let noti = UILabel()
        noti.text = "알림을 켜주세요."
        noti.font = UIFont.systemFont(ofSize: 30, weight: .semibold)

        noti.translatesAutoresizingMaskIntoConstraints = false
        return noti
    }()

    let notiDetailLabel: UILabel = {
        let noti = UILabel()
        noti.text = "앱의 알림을 받으려면 iOS설정에서 알림을 켜주세요."
        noti.numberOfLines = 2
        noti.font = UIFont.systemFont(ofSize: 15, weight: .semibold)

        noti.translatesAutoresizingMaskIntoConstraints = false
        return noti
    }()

     lazy var notiButton: UIButton = {
        let noti = UIButton()
        noti.tintColor = .duduDeepBlue
        noti.setTitle("설정으로", for: .normal)
        noti.setTitleColor(.white, for: .normal)
        noti.backgroundColor = .duduDeepBlue
        noti.layer.cornerRadius = 15
        noti.layer.borderWidth = 1
        noti.layer.borderColor = UIColor.black.cgColor

        noti.translatesAutoresizingMaskIntoConstraints = false
         noti.addTarget(self, action: #selector(tapButton(sender:)), for: .touchUpInside)
        return noti
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupNavigationController()

        let notiLabel: UILabel = notiLabel
        let notiDetailLabel: UILabel = notiDetailLabel
        let isPushOn = UIApplication.shared.isRegisteredForRemoteNotifications
        if isPushOn == true {
            print("push on")

            // disable
            notiLabel.text = "알림이 켜져있습니다."
            notiDetailLabel.text = "앱의 알림을 수정하시고 싶으시면 iOS설정에서 수정해주세요."
        } else {
            print("push off")
            // enable
            notiLabel.text = "알림을 켜주세요."
            notiDetailLabel.text = "앱의 알림을 받으려면 iOS설정에서 알림을 켜주세요."
        }

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
