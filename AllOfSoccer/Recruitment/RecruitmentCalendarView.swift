//
//  RecruitmentCalendarView.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/08/12.
//

import UIKit
import FSCalendar

class RecruitmentCalendarView: UIView {

    private var calendar = FSCalendar()
    private var monthButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        let buttonTitleColor = UIColor(red: 236/255, green: 95/255, blue: 95/255, alpha: 1)
        let buttonBackgroundColor = UIColor(red: 246/255, green: 247/255, blue: 250/255, alpha: 1)
        button.setTitleColor(buttonTitleColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.backgroundColor = buttonBackgroundColor
        button.setImage(UIImage.init(systemName: "chevron.down"), for: .normal)
        button.tintColor = buttonTitleColor
        return button
    }()
    private var yearButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        let buttonTitleColor = UIColor.black
        let buttonBackgroundColor = UIColor.white
        button.setTitleColor(buttonTitleColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.backgroundColor = buttonBackgroundColor
        button.setImage(UIImage.init(systemName: "chevron.down"), for: .normal)
        button.tintColor = buttonTitleColor
        return button
    }()
    private var timeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "시간"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    private var timeDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .inline
        return datePicker
    }()
    private var cancelButton: UIButton = {
        let button = UIButton()
        let backgroundColorDidDeSeleted = UIColor(red: 246/255, green: 247/255, blue: 250/255, alpha: 1)
        let backgroundColorDidSeleted = UIColor(red: 236/255, green: 95/255, blue: 95/255, alpha: 1)
        let titleColorDidDeSeleted = UIColor.black
        let titleColorDidSeleted = UIColor.white
        button.setBackgroundColor(backgroundColorDidDeSeleted, for: .normal)
        button.setBackgroundColor(backgroundColorDidSeleted, for: .selected)
        button.setTitleColor(titleColorDidDeSeleted, for: .normal)
        button.setTitleColor(titleColorDidSeleted, for: .selected)
        return button
    }()
    private var okButton: UIButton = {
        let button = UIButton()
        let backgroundColorDidDeSeleted = UIColor(red: 246/255, green: 247/255, blue: 250/255, alpha: 1)
        let backgroundColorDidSeleted = UIColor(red: 236/255, green: 95/255, blue: 95/255, alpha: 1)
        let titleColorDidDeSeleted = UIColor.black
        let titleColorDidSeleted = UIColor.white
        button.setBackgroundColor(backgroundColorDidDeSeleted, for: .normal)
        button.setBackgroundColor(backgroundColorDidSeleted, for: .selected)
        button.setTitleColor(titleColorDidDeSeleted, for: .normal)
        button.setTitleColor(titleColorDidSeleted, for: .selected)
        return button
    }()
    lazy private var yearAndmonthStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.monthButton, self.yearButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        return stackView
    }()
    lazy private var okAndCancelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.okButton, self.cancelButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }

    private func loadView() {
        setupViewConstraint()
        setupCalendar()
    }

    private func setupCalendar() {
        self.calendar.appearance.titleWeekendColor = UIColor.red
        self.calendar.appearance.selectionColor = UIColor.black
        self.calendar.appearance.todayColor = nil
        self.calendar.appearance.titleTodayColor = nil

        self.calendar.headerHeight = 0

        self.calendar.locale = Locale(identifier: "ko_KR")
        self.calendar.calendarWeekdayView.weekdayLabels[0].text = "일"
        self.calendar.calendarWeekdayView.weekdayLabels[1].text = "월"
        self.calendar.calendarWeekdayView.weekdayLabels[2].text = "화"
        self.calendar.calendarWeekdayView.weekdayLabels[3].text = "수"
        self.calendar.calendarWeekdayView.weekdayLabels[4].text = "목"
        self.calendar.calendarWeekdayView.weekdayLabels[5].text = "금"
        self.calendar.calendarWeekdayView.weekdayLabels[6].text = "토"

        self.calendar.delegate = self
        self.calendar.dataSource = self
        self.calendar.allowsMultipleSelection = true
    }

    private func setupViewConstraint() {
        self.addSubview(self.yearAndmonthStackView)
        self.yearAndmonthStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.yearAndmonthStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 24),
            self.yearAndmonthStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.yearAndmonthStackView.widthAnchor.constraint(equalToConstant: 144),
            self.yearAndmonthStackView.heightAnchor.constraint(equalToConstant: 40)
        ])

        self.addSubview(self.calendar)
        self.calendar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.calendar.topAnchor.constraint(equalTo: self.yearAndmonthStackView.bottomAnchor, constant: 0),
            self.calendar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 28),
            self.calendar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -28),
            self.calendar.heightAnchor.constraint(equalToConstant: 280)
        ])

        self.addSubview(self.timeTitleLabel)
        self.timeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.timeTitleLabel.topAnchor.constraint(equalTo: self.calendar.bottomAnchor, constant: 14),
            self.timeTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 38)
        ])

        self.addSubview(self.timeDatePicker)
        self.timeDatePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.timeDatePicker.centerYAnchor.constraint(equalTo: self.timeTitleLabel.centerYAnchor),
            self.timeDatePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -28),
        ])

        self.addSubview(self.okAndCancelStackView)
        self.okAndCancelStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.okAndCancelStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            self.okAndCancelStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            self.okAndCancelStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24),
            self.okAndCancelStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

// MARK: - FSCollectionViewDelegate
extension RecruitmentCalendarView: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {

    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {

    }

    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
}

// MARK: - FSCollectionViewDataSource
extension RecruitmentCalendarView: FSCalendarDataSource {

}


extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))

        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.setBackgroundImage(backgroundImage, for: state)
    }
}
