//
//  RouteTableHeader.swift
//  WidgetBus
//
//  Created by KoJeongseok on 2022/11/10.
//

import UIKit

class TitleHeader: UITableViewHeaderFooterView {

    // 정류장이름
    let busStopLabel: UILabel = {
        let label = UILabel()
        label.text = "출근"
        label.textColor = .white
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.addSubview(busStopLabel)

        NSLayoutConstraint.activate([
            self.busStopLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.busStopLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
    }
}
