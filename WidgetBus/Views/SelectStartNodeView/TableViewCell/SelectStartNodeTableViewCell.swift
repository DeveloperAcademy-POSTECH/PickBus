//
//  SelectStartNodeTableViewCell.swift
//  WidgetBus
//
//  Created by 김민재 on 2022/11/15.
//

import UIKit

class SelectStartNodeTableViewCell: UITableViewCell {

    @IBOutlet weak var nodeName: UILabel!
    @IBOutlet weak var nodeDirection: UILabel!
    @IBOutlet weak var nodeDistance: UILabel!

    @IBOutlet weak var mapView: UIView!

    static func nib() -> UINib {
        return UINib(nibName: "SelectStartNodeTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: 셀 확장 설정
    func settingData(isClicked: Bool) {
        mapView.isHidden = !isClicked
        self.backgroundColor = isClicked ? .duduBlue : .clear
    }

}
