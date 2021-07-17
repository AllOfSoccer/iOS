//
//  CalendarCollectionViewCell.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/07/15.
//

import UIKit

protocol ViewTappedDelegate: class {
    func viewTapped(_ cell: CalendarCollectionViewCell)
}

class CalendarCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    var indexPath: IndexPath? {
        didSet {
            setUI()
        }
    }
    var stackviewTappedBool: Bool = false

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var calendarStacview: UIStackView!
    weak var delegate: ViewTappedDelegate?

    override func awakeFromNib() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        tapGesture.delegate = self
        calendarStacview.isUserInteractionEnabled = true
        calendarStacview.addGestureRecognizer(tapGesture)
    }

    @objc func handleTap(recognizer:UITapGestureRecognizer) {
        delegate?.viewTapped(self)
        if stackviewTappedBool == false {
            calendarStacview.backgroundColor = .blue
            stackviewTappedBool = true
        } else {
            calendarStacview.backgroundColor = .clear
            stackviewTappedBool = false
        }
    }

    func setUI() {
        guard let indexPath = self.indexPath else { return }
        if indexPath.item % 7 == 6 {
            // 일요일
            dayLabel.textColor = .red
            dateLabel.textColor = .red
        } else if indexPath.item % 7 == 5 {
            // 토요일
            dayLabel.textColor = .blue
            dateLabel.textColor = .blue
        } else {
            // 평일
            dayLabel.textColor = .black
            dateLabel.textColor = .black
        }
    }
}
