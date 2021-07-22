//
//  CalendarCollectionViewCell.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/07/15.
//

import UIKit

protocol ViewTappedDelegate: AnyObject {
    func viewTapped(_ cell: CalendarCollectionViewCell)
}

class CalendarCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    @IBOutlet private weak var calendarStackView: UIStackView!
    weak var delegate: ViewTappedDelegate?

    override func awakeFromNib() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        tapGesture.delegate = self
        calendarStackView.isUserInteractionEnabled = true
        calendarStackView.addGestureRecognizer(tapGesture)
    }

    @objc func handleTap(recognizer:UITapGestureRecognizer) {
        delegate?.viewTapped(self)
    }

    func configure(_ cellData: CellData) {
        guard let indexPath = cellData.indexPath else { return }
        dayLabel.text = cellData.weeks[cellData.dayOfTheWeek! % 7]
        dateLabel.text = cellData.date

        if cellData.dayOfTheWeek! % 7 == NumberOfDays.sunday.rawValue {
            // 일요일
            dayLabel.textColor = .red
            dateLabel.textColor = .red
        } else if cellData.dayOfTheWeek! % 7 == NumberOfDays.saturday.rawValue {
            // 토요일
            dayLabel.textColor = .blue
            dateLabel.textColor = .blue
        } else {
            // 평일
            dayLabel.textColor = .black
            dateLabel.textColor = .black
        }

        if  cellData.stackviewTappedBool == true {
            calendarStackView.backgroundColor = .blue
        } else {
            calendarStackView.backgroundColor = .clear
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
