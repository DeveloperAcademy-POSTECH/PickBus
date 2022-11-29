//
//  RouteTableViewCell.swift
//  WidgetBus
//
//  Created by KoJeongseok on 2022/11/10.
//

import UIKit

class RouteCell: UITableViewCell {

    var busNumver: String = ""

    // 버스번호
    private lazy var busNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // 버스번호 배경
    private lazy var busNumberBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .duduDeepBlue
        view.layer.cornerRadius = 9
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // 버스남은시간
    private lazy var busRemainingTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // 다음버스남은시간
    private lazy var nextBusRemainingTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .duduGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // 탑승버튼
    private lazy var rideButton: UIButton = {
        let button = UIButton()
        button.setTitle("탑승", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        button.setTitleColor(.duduDeepBlue, for: .normal)
        button.backgroundColor = .duduBlue
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.duduDeepBlue?.cgColor
        button.addTarget(self, action: #selector(pressedRideButton(_ :)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        self.contentView.addSubview(busNumberBackgroundView)
        self.contentView.addSubview(busNumberLabel)
        self.contentView.addSubview(busRemainingTimeLabel)
        self.contentView.addSubview(nextBusRemainingTimeLabel)
        self.contentView.addSubview(rideButton)

        NSLayoutConstraint.activate([
            // 버스번호 배경
            busNumberBackgroundView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            busNumberBackgroundView.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor, constant: 16),
            busNumberBackgroundView.widthAnchor.constraint(equalToConstant: 80),
            busNumberBackgroundView.heightAnchor.constraint(equalToConstant: 30),

            // 버스번호
            busNumberLabel.centerYAnchor.constraint(equalTo: self.busNumberBackgroundView.centerYAnchor),
            busNumberLabel.centerXAnchor.constraint(equalTo: busNumberBackgroundView.centerXAnchor),
            busNumberLabel.widthAnchor.constraint(equalToConstant: 60),
            busNumberLabel.heightAnchor.constraint(equalToConstant: 30),

            // 버스남은시간
            busRemainingTimeLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            busRemainingTimeLabel.leadingAnchor.constraint(
                equalTo: self.contentView.centerXAnchor, constant: -20),

            // 다음버스남은시간
            nextBusRemainingTimeLabel.bottomAnchor.constraint(
                equalTo: self.busRemainingTimeLabel.bottomAnchor),
            nextBusRemainingTimeLabel.leadingAnchor.constraint(
                equalTo: self.busRemainingTimeLabel.trailingAnchor,
                constant: 14),

            // 탑승버튼
            rideButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            rideButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            rideButton.widthAnchor.constraint(equalToConstant: 38),
            rideButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    @objc func pressedRideButton(_ sender: UIButton) {
        print(busNumver)
    }

    func setCell(busNumber: String, busRemainingTime: String, nextBusRemainingTime: String) {
        self.busNumver = busNumber
        self.busNumberLabel.text = busNumber
        self.busRemainingTimeLabel.text = busRemainingTime
        self.nextBusRemainingTimeLabel.text = nextBusRemainingTime
    }
}
