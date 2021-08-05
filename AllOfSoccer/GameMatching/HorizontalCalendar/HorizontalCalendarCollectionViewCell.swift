//
//  CalendarCollectionViewCell.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/07/15.
//

import UIKit


enum NumberOfDays: Int {
    case saturday = 0
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case webseday = 4
    case thursday = 5
    case friday = 6
}

class HorizontalCalendarCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var stackView: UIStackView!

    override func awakeFromNib() {
        self.stackView.layer.cornerRadius = 15
    }

    override var isSelected: Bool {
        didSet {
            let didSelectedColor = UIColor(red: 242.0/255.0, green: 243.0/255.0, blue: 245.0/255.0, alpha: 1)
            let didDeSelectedColor = UIColor.white
            self.stackView.backgroundColor = isSelected ? didSelectedColor : didDeSelectedColor
        }
    }

    func configure(_ cellData: HorizontalCalendarModel) {
        guard let dayOfTheWeek = cellData.dayOfTheWeek else { return }
        self.dayLabel.text = cellData.weeks[dayOfTheWeek % 7]
        self.dateLabel.text = cellData.date

        if dayOfTheWeek % 7 == NumberOfDays.sunday.rawValue {
            // 일요일
            self.dayLabel.textColor = .red
            self.dateLabel.textColor = .red
        } else if dayOfTheWeek % 7 == NumberOfDays.saturday.rawValue {
            // 토요일
            self.dayLabel.textColor = .blue
            self.dateLabel.textColor = .blue
        } else {
            // 평일
            self.dayLabel.textColor = .black
            self.dateLabel.textColor = .black
        }
    }
}
