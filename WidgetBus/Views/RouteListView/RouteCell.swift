//
//  RouteTableViewCell.swift
//  WidgetBus
//
//  Created by KoJeongseok on 2022/11/10.
//

import UIKit

final class RouteCell: UITableViewCell {

    // 남은 정류장
    var arrprevstationcnt: Int = 1000

    // 남은 시간
    var arrTime: String = "" {
        didSet {
            switch arrprevstationcnt {
            case 1:
                busRemainingTimeLabel.text = "곧도착"
            case 2:
                busRemainingTimeLabel.text = "전전"
            default:
                busRemainingTimeLabel.text = arrTime
            }
        }
    }

    // 다음 남은 시간
    var nextArrTime: String = ""

    // 버스번호
    var busNumberLabel: UILabel = {
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
        label.text = arrTime
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // 다음버스남은시간
    private lazy var nextBusRemainingTimeLabel: UILabel = {
        let label = UILabel()
        label.text = nextArrTime
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
        self.addSubview(busNumberBackgroundView)
        self.addSubview(busNumberLabel)
        self.addSubview(busRemainingTimeLabel)
        self.addSubview(nextBusRemainingTimeLabel)
        self.addSubview(rideButton)

        NSLayoutConstraint.activate([
            // 버스번호 배경
            busNumberBackgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            busNumberBackgroundView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: 16),
            busNumberBackgroundView.widthAnchor.constraint(equalToConstant: 80),
            busNumberBackgroundView.heightAnchor.constraint(equalToConstant: 30),

            // 버스번호
            busNumberLabel.centerYAnchor.constraint(equalTo: busNumberBackgroundView.centerYAnchor),
            busNumberLabel.centerXAnchor.constraint(equalTo: busNumberBackgroundView.centerXAnchor),
            busNumberLabel.widthAnchor.constraint(equalToConstant: 60),
            busNumberLabel.heightAnchor.constraint(equalToConstant: 30),

            // 버스남은시간
            busRemainingTimeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            busRemainingTimeLabel.leadingAnchor.constraint(
                equalTo: self.centerXAnchor, constant: -20),

            // 다음버스남은시간
            nextBusRemainingTimeLabel.bottomAnchor.constraint(
                equalTo: self.busRemainingTimeLabel.bottomAnchor),
            nextBusRemainingTimeLabel.leadingAnchor.constraint(
                equalTo: self.busRemainingTimeLabel.trailingAnchor,
                constant: 14),

            // 탑승버튼
            rideButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            rideButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            rideButton.widthAnchor.constraint(equalToConstant: 38),
            rideButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    @objc func pressedRideButton(_ sender: UIButton) {
        // 버스번호 넘기면서 디테일뷰로 이동
    }
}
