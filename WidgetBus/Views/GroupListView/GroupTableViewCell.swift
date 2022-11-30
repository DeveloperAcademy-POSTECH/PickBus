//
//  GroupListTableViewCell.swift
//  WidgetBus
//
//  Created by Shin yongjun on 2022/11/14.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

        lazy var groupListLabel: UILabel = {
        let label = UILabel()
        label.text = "루트그룹명"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center

        label.backgroundColor = .duduDeepBlue
        label.layer.masksToBounds = true
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 15
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.8
        label.layer.shadowOffset = CGSize(width: 2, height: 20)
        label.layer.shadowRadius = 2.0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        self.contentView.addSubview(groupListLabel)
        groupListLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        groupListLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        groupListLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
        groupListLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15)
            .isActive = true
        groupListLabel.heightAnchor.constraint(equalToConstant: 75).isActive = true
    }
}
