//
//  RouteTableHeaderCell.swift
//  WidgetBus
//
//  Created by KoJeongseok on 2022/11/15.
//

import UIKit

class BusStopCell: UITableViewCell {

    var isNoti: Bool = false

    // 정류장이름
    let busStopLabel: UILabel = {
        let label = UILabel()
        label.text = "정류장이름"
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // 알림 버튼
    private lazy var notiButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(pressedNotiButton(_ :)), for: .touchUpInside)
        button.setImage(UIImage(systemName: "bell"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white

    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        self.contentView.addSubview(busStopLabel)
        self.contentView.addSubview(notiButton)

        NSLayoutConstraint.activate([
            // 버스정류장 라벨
            busStopLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            busStopLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            // 알림 버튼
            notiButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            notiButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    @objc private func pressedNotiButton(_ sender: UIButton) {
        isNoti = !isNoti
        notiButton.setImage(
            UIImage(systemName: isNoti ? "bell.fill" : "bell"), for: .normal
        )
    }
}
