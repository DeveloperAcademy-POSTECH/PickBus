//
//  AddRouteTableViewCell.swift
//  WidgetBus
//
//  Created by KoJeongseok on 2022/11/10.
//

import UIKit

final class AddRouteCell: UITableViewCell {

    // 루트추가 이미지
    private let addImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "duduPlus")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    // 루트추가 문구
    private let addLabel: UILabel = {
        let label = UILabel()
        label.text = "새 경로를 추가해주세요"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.layer.cornerRadius = 15
        self.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(addImageView)
        self.addSubview(addLabel)

        NSLayoutConstraint.activate([
            // 플러스 이미지
            addImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            addImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            // 플러스 라벨
            addLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            addLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}
