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
        noti.text = "알림 설정 Off"
        noti.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return noti
    }()

    lazy var notiSetting: UISwitch = {
        let noti = UISwitch()
        noti.tintColor = UIColor.green
        noti.isOn = false
        noti.addTarget(self, action: #selector(onClickSwitch(sender:)), for: UIControl.Event.valueChanged)
        return noti
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupNavigationController()
        let notiText: UILabel = notiLabel

        let isPushOn = UIApplication.shared.isRegisteredForRemoteNotifications

        if isPushOn {
            print("push on")
            // disable
            UIApplication.shared.unregisterForRemoteNotifications()
            notiText.text = "알림 설정 On"
        } else {
            print("push off")
            // enable
            UIApplication.shared.registerForRemoteNotifications()
            notiText.text = "알림 설정 Off"
        }
    }

    @objc func onClickSwitch(sender: UISwitch) {
        let notiText: UILabel = notiLabel

           if sender.isOn {
               if let appSettings = NSURL(string: UIApplication.openSettingsURLString) {
                   UIApplication.shared.open(appSettings as URL)
               }
               notiText.text = "알림 설정 On"
               UNUserNotificationCenter.current().delegate = self
           } else {
               if let appSettings = NSURL(string: UIApplication.openSettingsURLString) {
                   UIApplication.shared.open(appSettings as URL)
               }
               notiText.text = "알림 설정 Off"
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
        view.addSubview(notiSetting)
        notiSetting.translatesAutoresizingMaskIntoConstraints = false
        notiSetting.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        notiSetting.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

        view.addSubview(notiLabel)
        notiLabel.translatesAutoresizingMaskIntoConstraints = false
        notiLabel.topAnchor.constraint(equalTo: notiSetting.topAnchor).isActive = true
        notiLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    }
}
