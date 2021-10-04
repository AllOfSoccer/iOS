//
//  CalendarView.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/10/04.
//

import UIKit
import FSCalendar

protocol GameMatchingCalendarViewDelegate: AnyObject {
    func cancelButtonDidSelected(_ sender: GameMatchingCalendarView)
    func okButtonDidSelected(_ sender: GameMatchingCalendarView)
}

class GameMatchingCalendarView: UIView {

    weak var delegate: GameMatchingCalendarViewDelegate?

    private var selectedDate: [String] = []
    private var currentPage: Date?

    private var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.appearance.titleWeekendColor = UIColor.red
        calendar.appearance.selectionColor = UIColor.black
        calendar.appearance.todayColor = nil
        calendar.appearance.titleTodayColor = nil

        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.headerDateFormat = "M월"
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 20, weight: .bold)

        calendar.locale = Locale(identifier: "ko-KR")
        calendar.calendarWeekdayView.weekdayLabels[0].text = "일"
        calendar.calendarWeekdayView.weekdayLabels[0].text = "월"
        calendar.calendarWeekdayView.weekdayLabels[0].text = "화"
        calendar.calendarWeekdayView.weekdayLabels[0].text = "수"
        calendar.calendarWeekdayView.weekdayLabels[0].text = "목"
        calendar.calendarWeekdayView.weekdayLabels[0].text = "금"
        calendar.calendarWeekdayView.weekdayLabels[0].text = "토"

        calendar.allowsMultipleSelection = true

        return calendar
    }()

    private var monthPrevButton: UIButton = {
        let button = UIButton()

        button.addTarget(self, action: #selector(monthBackButtonTouchUp), for: .touchUpInside)

        return button
    }()

    private var monthNextButton: UIButton = {
        let button = UIButton()

        button.addTarget(self, action: #selector(monthNextButtonTouchUp), for: .touchUpInside)

        return button
    }()

    private var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.setTitleColor(UIColor.black, for: .normal)
        let backgroundColor = UIColor(red: 246/255, green: 247/255, blue: 250/255, alpha: 1)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true

        button.addTarget(self, action: #selector(cancelButtonTouchUp), for: .touchUpInside)

        return button
    }()

    private var okButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("선택", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.setTitleColor(UIColor.white, for: .normal)
        let backgroundColor = UIColor(red: 236/255, green: 95/255, blue: 95/255, alpha: 1)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true

        button.addTarget(self, action: #selector(okButtonTouchUp), for: .touchUpInside)

        return button
    }()

    lazy private var okAndCancelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.cancelButton, self.okButton])
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

        setSuperView()
        setCalendar()
        setViewConstraint()
    }

    private func setSuperView() {
        self.layer.cornerRadius = 12
    }

    private func setCalendar() {

        calendar.delegate = self
        calendar.dataSource = self
    }

    private func setViewConstraint() {

        self.addsubviews(self.okAndCancelStackView, self.calendar)
        self.calendar.addsubviews(self.monthPrevButton, self.monthNextButton)

        NSLayoutConstraint.activate([
            self.okAndCancelStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            self.okAndCancelStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            self.okAndCancelStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24),
            self.okAndCancelStackView.heightAnchor.constraint(equalToConstant: 40),

            self.calendar.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.calendar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            self.calendar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            self.calendar.bottomAnchor.constraint(equalTo: self.okAndCancelStackView.topAnchor, constant: 0),

            self.monthPrevButton.topAnchor.constraint(equalTo: calendar.topAnchor, constant: 25),
            self.monthPrevButton.leadingAnchor.constraint(equalTo: calendar.leadingAnchor, constant: 25),
            self.monthPrevButton.widthAnchor.constraint(equalToConstant: 14),
            self.monthPrevButton.widthAnchor.constraint(equalToConstant: 14),

            self.monthNextButton.topAnchor.constraint(equalTo: calendar.topAnchor, constant: 25),
            self.monthNextButton.trailingAnchor.constraint(equalTo: calendar.trailingAnchor, constant: -25),
            self.monthNextButton.widthAnchor.constraint(equalToConstant: 14),
            self.monthNextButton.widthAnchor.constraint(equalToConstant: 14),
        ])
    }

    @objc private func cancelButtonTouchUp(sender: UIButton) {
        self.delegate?.cancelButtonDidSelected(self)
    }

    @objc private func okButtonTouchUp(sender: UIButton) {
        self.delegate?.okButtonDidSelected(self)
    }

    @objc private func monthBackButtonTouchUp(_ sender: UIButton) {
        moveCurrentPage(moveUp: false)
    }

    @objc private func monthNextButtonTouchUp(_ sender: UIButton) {
        moveCurrentPage(moveUp: true)
    }

    private func moveCurrentPage(moveUp: Bool) {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = moveUp ? 1 : -1

        self.currentPage = calendar.date(byAdding: dateComponents, to: self.currentPage ?? Date())
        guard let currentPage = self.currentPage else { return }
        self.calendar.setCurrentPage(currentPage, animated: true)
    }
}

// MARK: - FSCollectionViewDelegate
extension GameMatchingCalendarView: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {

        appendDate(date: date)
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {

        deleteDate(date: date)
    }

    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }

    private func appendDate(date: Date) {
        let dateFormatter = DateFormatter()
        let stringDate = dateFormatter.string(from: date)
        self.selectedDate.append(stringDate)
        let countOfSeletedDate = self.selectedDate.count
        let buttonTitle = self.selectedDate.isEmpty ? "선택" : "선택 (\(countOfSeletedDate)건)"
        self.okButton.setTitle(buttonTitle, for: .normal)
    }

    private func deleteDate(date: Date) {
        let dateFormatter = DateFormatter()
        let stringDate = dateFormatter.string(from: date)
        guard let indexOfStringDate = selectedDate.firstIndex(of: stringDate) else { return }
        self.selectedDate.remove(at: indexOfStringDate)
        let countOfSeletedDate = self.selectedDate.count
        let buttonTitle = self.selectedDate.isEmpty ? "선택" : "선택 (\(countOfSeletedDate)건)"
        self.okButton.setTitle(buttonTitle, for: .normal)
    }
}

// MARK: - FSCollectionViewDataSource
extension GameMatchingCalendarView: FSCalendarDataSource {

}
