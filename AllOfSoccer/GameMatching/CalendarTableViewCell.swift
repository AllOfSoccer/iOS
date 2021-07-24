//
//  CalendarTableViewCell.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/07/22.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {

    private let calendarView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .black
        return uiView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func setConsraint() {
        contentView.addSubview(calendarView)
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
        }
    }
}
