//
//  GameMatchingViewController.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/07/04.
//

import UIKit
import FSCalendar
import SnapKit

class GameMatchingViewController: UIViewController {
    private var selectedDate: [String] = []

    private var weeks: [String] = ["월","화","수","목","금","토","일"]
    private var components = DateComponents()
    private let now = Date()
    private let dateFormatter = DateFormatter()
    private var cellDataArray
        : [CellData] = []
    private var currentPage: Date?

    private lazy var today: Date = {
        return Date()
    }()

    private lazy var seletCalendarView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()

    private lazy var calendarButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        return button
    }()

    private lazy var calendarView: FSCalendar = {
        let view = FSCalendar()
        return view
    }()

    private lazy var calendarPrevButton: UIButton = {
        let button = UIButton()
        button.setTitle("이전", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    private lazy var calendarNextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    @IBOutlet private weak var teamMatchButton: SelectTableButton!
    @IBOutlet private weak var manMatchButton: SelectTableButton!
    @IBOutlet private weak var selectedLineCenterConstraint: NSLayoutConstraint!
    @IBOutlet private weak var monthButton: UIButton!
    @IBOutlet private weak var
        calendarCollectionView: UICollectionView!

    @IBAction private func teamMatchButtonTouchUp(_ sender: Any) {
        teamMatchButton.isSelected = true
        manMatchButton.isSelected = false

        UIView.animate(withDuration: 0.1) {
            self.selectedLineCenterConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }

    @IBAction private func manMatchButtonTouchUp(_ sender: Any) {
        self.teamMatchButton.isSelected = false
        self.manMatchButton.isSelected = true

        let constant = manMatchButton.center.x - teamMatchButton.center.x

        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.selectedLineCenterConstraint.constant = constant
            self?.view.layoutIfNeeded()
        }
    }

    @IBAction func monthButtonTouchUp(_ sender: UIButton) {
        self.seletCalendarView.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        calendarCollectionViewDefaultSetting()
        selectCalendarViewDefaultSetting()
    }

    private
    func calendarCollectionViewDefaultSetting() {
        self.calendarCollectionView.delegate = self
        self.calendarCollectionView.dataSource = self

        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.minimumInteritemSpacing = 15
        flowlayout.minimumLineSpacing = 10
        flowlayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowlayout.scrollDirection = .horizontal

        let itemWidth = (UIScreen.main.bounds.width - 84) / 10
        //        let itemWidth = ((UIScreen.main.bounds.width - (10 * (rowItemCount - 1))) / rowItemCount)
        flowlayout.itemSize = CGSize(width: itemWidth, height: 96)
        calendarCollectionView.collectionViewLayout = flowlayout

    }

    private func selectCalendarViewDefaultSetting() {
        self.view.addSubview(seletCalendarView)
        self.seletCalendarView.snp.makeConstraints { (make) in
            make.width.equalTo(315)
            make.height.equalTo(406)
            make.center.equalTo(self.view)
        }

        self.seletCalendarView.addSubview(calendarButton)
        self.calendarButton.snp.makeConstraints { (make) in
            make.width.equalTo(seletCalendarView)
            make.height.equalTo(63)
            make.bottom.equalTo(seletCalendarView)
        }

        self.seletCalendarView.addSubview(calendarView)
        self.calendarView.snp.makeConstraints { (make) in
            make.top.equalTo(seletCalendarView)
            make.bottom.equalTo(calendarButton.snp.top)
            make.width.equalTo(seletCalendarView)
        }

        self.seletCalendarView.isHidden = true

        self.calendarButton.addTarget(self, action: #selector(calendarButtonTouchUp), for: .touchUpInside)

        self.calendarView.delegate = self
        self.calendarView.dataSource = self

        self.calendarView.appearance.titleWeekendColor = UIColor.red
        self.calendarView.appearance.selectionColor = UIColor.black
        self.calendarView.appearance.todayColor = UIColor.blue

        self.calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        self.calendarView.appearance.headerDateFormat = "YYYY년 M월"
        self.calendarView.appearance.headerTitleColor = .black

        self.calendarView.locale = Locale(identifier: "ko_KR")
        self.calendarView.calendarWeekdayView.weekdayLabels[0].text = "일"
        self.calendarView.calendarWeekdayView.weekdayLabels[1].text = "월"
        self.calendarView.calendarWeekdayView.weekdayLabels[2].text = "화"
        self.calendarView.calendarWeekdayView.weekdayLabels[3].text = "수"
        self.calendarView.calendarWeekdayView.weekdayLabels[4].text = "목"
        self.calendarView.calendarWeekdayView.weekdayLabels[5].text = "금"
        self.calendarView.calendarWeekdayView.weekdayLabels[6].text = "토"

        self.calendarView.allowsMultipleSelection = true

        self.calendarView.addSubview(calendarPrevButton)
        self.calendarPrevButton.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.top)
            make.left.equalTo(calendarView.snp.left)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }

        self.calendarView.addSubview(calendarNextButton)
        self.calendarNextButton.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.top)
            make.right.equalTo(calendarView.snp.right)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }

        self.calendarPrevButton.addTarget(self, action: #selector(monthBackButtonPressed), for: .touchUpInside)
        self.calendarNextButton.addTarget(self, action: #selector(monthNextButtonPressed), for: .touchUpInside)

        self.dateFormatter.dateFormat = "yyyy-MM-dd"
    }

    @objc private func calendarButtonTouchUp() {
        self.seletCalendarView.isHidden = true
    }

    @objc private func monthBackButtonPressed() {
        moveCurrentPage(moveUp: false)
    }

    @objc private func monthNextButtonPressed() {
        moveCurrentPage(moveUp: true)
    }

    private func moveCurrentPage(moveUp: Bool) {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = moveUp ? 1 : -1

        self.currentPage = calendar.date(byAdding: dateComponents, to: self.currentPage ?? self.today)
        guard let currentPage = self .currentPage else { return }
        self.calendarView.setCurrentPage(currentPage, animated: true)
    }
}

extension GameMatchingViewController: UICollectionViewDelegate {
}

extension GameMatchingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellDataArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCollectionViewCell", for: indexPath) as? CalendarCollectionViewCell else {
            return .init()
        }

        cellDataArray[indexPath.item].indexPath = indexPath
        cell.configure(self.cellDataArray[indexPath.item])
        cell.delegate = self

        return cell
    }
}

extension GameMatchingViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let stringDate = dateFormatter.string(from: date)
        self.selectedDate.append(stringDate)
        let countOfSeletedDate = self.selectedDate.count
        let buttonTitle = "선택 적용하기 (\(countOfSeletedDate))"
        self.calendarButton.setTitle(buttonTitle, for: .normal)
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let stringDate = dateFormatter.string(from: date)
        guard let indexOfStringDate = selectedDate.firstIndex(of: stringDate) else { return }
        self.selectedDate.remove(at: indexOfStringDate)
        let countOfSeletedDate = self.selectedDate.count
        let buttonTitle = "선택 적용하기 (\(countOfSeletedDate))"
        self.calendarButton.setTitle(buttonTitle, for: .normal)
    }
}

extension GameMatchingViewController: FSCalendarDataSource {

}

extension GameMatchingViewController: CalendarCellTappedDelegate {
    func viewTapped(_ cell: CalendarCollectionViewCell) {
        guard let indexPath = calendarCollectionView.indexPath(for: cell) else { return }
        if cellDataArray[indexPath.item].stackviewTappedBool == false {
            cellDataArray[indexPath.item].stackviewTappedBool = true
        } else {
            cellDataArray[indexPath.item].stackviewTappedBool = false
        }
        self.calendarCollectionView.reloadData()
    }
}
