//
//  CalendarCollectionViewCell.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/07/15.
//

import UIKit

protocol CalendarCellTappedDelegate: class {
    func viewTapped(_ cell: CalendarCollectionViewCell)
}

class CalendarCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    @IBOutlet private weak var calendarStacview: UIStackView!
    weak var delegate: CalendarCellTappedDelegate?

    override func awakeFromNib() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        tapGesture.delegate = self
        calendarStacview.isUserInteractionEnabled = true
        calendarStacview.addGestureRecognizer(tapGesture)
    }

    @objc func handleTap(recognizer:UITapGestureRecognizer) {
        delegate?.viewTapped(self)
    }

    func configure(_ cellData: CellData) {
        guard let indexPath = cellData.indexPath else { return }
        dayLabel.text = cellData.weeks[indexPath.item % 7]
        dateLabel.text = cellData.day

        if indexPath.item % 7 == NumberOfDays.sunday.rawValue {
            // 일요일
            dayLabel.textColor = .red
            dateLabel.textColor = .red
        } else if indexPath.item % 7 == NumberOfDays.saturday.rawValue {
            // 토요일
            dayLabel.textColor = .blue
            dateLabel.textColor = .blue
        } else {
            // 평일
            dayLabel.textColor = .black
            dateLabel.textColor = .black
        }

        if  cellData.stackviewTappedBool == true {
            calendarStacview.backgroundColor = .blue
        } else {
            calendarStacview.backgroundColor = .clear
        }
    }
}

enum NumberOfDays: Int {
    case monday = 0
    case tuesday = 1
    case webseday = 2
    case thursday = 3
    case friday = 4
    case saturday = 5
    case sunday = 6
}
