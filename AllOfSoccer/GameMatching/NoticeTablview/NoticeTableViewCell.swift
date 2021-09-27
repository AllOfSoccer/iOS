//
//  NoticeTableViewCell.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/08/03.
//

import UIKit

class NoticeTableViewCell: UITableViewCell {

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var placeLabel: UILabel!
    @IBOutlet private weak var contentsLabel: UILabel!
    @IBOutlet private weak var teamImageView: UIImageView!
    @IBOutlet private weak var teamNameLabel: UILabel!
    @IBOutlet private weak var checkbutton: UIButton!
    @IBOutlet private weak var recruitmentStatusLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        setCheckButton()
    }

    private func setCheckButton() {
        self.checkbutton.setImage(UIImage.init(systemName: "heart"), for: .normal)
        self.checkbutton.setImage(UIImage.init(systemName: "heart.fill"), for: .selected)

        self.checkbutton.addTarget(self, action: #selector(checkButtonDidSelected), for: .touchUpInside)
    }

    @objc private func checkButtonDidSelected(sender: UIButton) {
        sender.isSelected = sender.isSelected == true ? false : true
        let didSelectedColor = UIColor(red: 236.0/255.0, green: 95.0/255.0, blue: 95.0/255.0, alpha: 1)
        let didDeSelectedColor = UIColor.black
        sender.tintColor = sender.isSelected ? didSelectedColor : didDeSelectedColor
    }
}
