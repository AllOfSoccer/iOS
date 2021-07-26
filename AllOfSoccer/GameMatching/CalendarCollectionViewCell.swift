//
//  CalendarCollectionViewCell.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/07/15.
//

import UIKit

protocol CalendarCellTappedDelegate: class {
    func cellTapped(_ cell: CalendarCollectionViewCell)
}

class CalendarCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    @IBOutlet private weak var calendarStacview: UIStackView!
    weak var delegate: CalendarCellTappedDelegate?

    override func awakeFromNib() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        tapGesture.delegate = self
        self.calendarStackView.isUserInteractionEnabled = true
        self.calendarStackView.addGestureRecognizer(tapGesture)
    }

    @objc func handleTap(recognizer:UITapGestureRecognizer) {
        delegate?.cellTapped(self)
    }

    func configure(_ cellData: CellData) {
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

        if  cellData.stackviewTappedBool == true {
            self.calendarStackView.backgroundColor = .blue
        } else {
            self.calendarStackView.backgroundColor = .clear
        }
    }
}

enum NumberOfDays: Int {
    case saturday = 0
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case webseday = 4
    case thursday = 5
    case friday = 6
}
