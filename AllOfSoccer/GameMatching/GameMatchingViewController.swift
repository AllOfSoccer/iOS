//
//  GameMatchingViewController.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/07/04.
//

import UIKit
import FSCalendar
import SnapKit

enum Mode {
    case teamMatching
    case manMatching
}

class GameMatchingViewController: UIViewController {

    private var selectedDate: [String] = []

    private var weeks: [String] = ["월","화","수","목","금","토","일"]
    private var components = DateComponents()
    private let now = Date()
    private let dateFormatter = DateFormatter()
    private var cellDataArray
        : [CellData] = []
<<<<<<< Updated upstream
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
=======
    private var tagCellDataArray: [String] = ["장소", "시간대", "경기", "참가비", "실력", "11111", "2222222", "333333"]
    private var tappedTagCellData: [String] = []
    private var resetButtonIsSelected: Bool?
>>>>>>> Stashed changes

    @IBOutlet private weak var teamMatchButton: SelectTableButton!
    @IBOutlet private weak var manMatchButton: SelectTableButton!
    @IBOutlet private weak var selectedLineCenterConstraint: NSLayoutConstraint!
    @IBOutlet private weak var monthButton: UIButton!
    @IBOutlet private weak var
        calendarCollectionView: UICollectionView!

    @IBOutlet private weak var tagCollectionView: UICollectionView!
    @IBOutlet private weak var refreshButtonView: UIView!
    @IBOutlet private weak var tagCollectionViewConstraint: NSLayoutConstraint!

    @IBAction private func teamMatchButtonTouchUp(_ sender: Any) {
        self.teamMatchButton.isSelected = true
        self.manMatchButton.isSelected = false

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

<<<<<<< Updated upstream
    @IBAction func monthButtonTouchUp(_ sender: UIButton) {
        self.seletCalendarView.isHidden = false
=======
    @IBAction private func resetTagCollectionView(_ sender: UIButton) {
        self.tappedTagCellData.removeAll()
        self.resetButtonIsSelected = true
        self.tagCollectionView.reloadData()

        self.tagCollectionViewCellIsNotSelectedViewSetting()
>>>>>>> Stashed changes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
<<<<<<< Updated upstream
        calendarCollectionViewDefaultSetting()
        selectCalendarViewDefaultSetting()
=======

        // CalendarCollectionView Default Setting
        self.calendarCollectionView.delegate = self
        self.calendarCollectionView.dataSource = self

        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.minimumInteritemSpacing = 15
        flowlayout.minimumLineSpacing = 10
        flowlayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowlayout.scrollDirection = .horizontal

        let itemWidth = (UIScreen.main.bounds.width - 84) / 9
        flowlayout.itemSize = CGSize(width: itemWidth, height: 96)
        self.calendarCollectionView.collectionViewLayout = flowlayout
>>>>>>> Stashed changes

        let dateRange = 1000
        for nextDay in 0...dateRange {
            var cellData = CellData()
            cellData.date = makeDate(nextDay)
            cellData.dayOfTheWeek = makeDayOfTheWeek(nextDay)
            cellData.stackviewTappedBool = false
            self.cellDataArray.append(cellData)
        }
        self.monthButton.setTitle(makeMonthButtonText(), for: .normal)

        // TagCollectionView Default Setting
        self.tagCollectionView.delegate = self
        self.tagCollectionView.dataSource = self

        let tagCollectionViewLayout = UICollectionViewFlowLayout()
        tagCollectionViewLayout.estimatedItemSize = CGSize(width: 500, height: 28)
        tagCollectionViewLayout.minimumInteritemSpacing = 6
        tagCollectionViewLayout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        tagCollectionViewLayout.scrollDirection = .horizontal
        self.tagCollectionView.collectionViewLayout = tagCollectionViewLayout

        tagCollectionViewCellIsNotSelectedViewSetting()

        self.resetButtonIsSelected = false
    }

    private func makeDate(_ plusValue: Int) -> String {
        let calendar = Calendar.current
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        guard let chagedDate = calendar.date(byAdding: .day, value: plusValue, to: currentDate) else { return "" }
        dateFormatter.dateFormat = "M/d"
        let dateString = dateFormatter.string(from: chagedDate)
        return dateString
    }

    private func makeDayOfTheWeek(_ plusValue: Int) -> Int? {
        let calendar = Calendar.current
        let currentDate = Date()
        guard let chagedDate = calendar.date(byAdding: .day, value: plusValue, to: currentDate) else { return nil}
        let dayOfTheWeekint = calendar.component(.weekday, from: chagedDate)
        return dayOfTheWeekint
    }

    private func makeMonthButtonText() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월"
        let monthString = dateFormatter.string(from: currentDate)
        return monthString
    }

<<<<<<< Updated upstream
    private
    func calendarCollectionViewDefaultSetting() {
        self.calendarCollectionView.delegate = self
        self.calendarCollectionView.dataSource = self

        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.minimumInteritemSpacing = 15
        flowlayout.minimumLineSpacing = 10
        flowlayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowlayout.scrollDirection = .horizontal

        let itemWidth = (UIScreen.main.bounds.width - 84) / 9
        flowlayout.itemSize = CGSize(width: itemWidth, height: 96)
        self.calendarCollectionView.collectionViewLayout = flowlayout
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

        self.seletCalendarView.isHidden = true

        self.calendarView.delegate = self
        self.calendarView.dataSource = self

        self.calendarView.allowsMultipleSelection = true

        self.calendarButton.addTarget(self, action: #selector(calendarButtonTouchUp), for: .touchUpInside)
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
=======
    private func tagCollectionViewCellIsNotSelectedViewSetting() {
        self.tagCollectionViewConstraint.constant = -(refreshButtonView.frame.width)
        self.refreshButtonView.isHidden = true
    }

    private func tagCollectionViewCellIsSelectedViewSetting() {
        self.tagCollectionViewConstraint.constant = 0
        self.refreshButtonView.isHidden = false
>>>>>>> Stashed changes
    }
}

extension GameMatchingViewController: UICollectionViewDelegate {
<<<<<<< Updated upstream
=======
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
>>>>>>> Stashed changes

}
extension GameMatchingViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.calendarCollectionView {
            return self.cellDataArray.count
        } else {
            return self.tagCellDataArray.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.calendarCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCollectionViewCell", for: indexPath) as? CalendarCollectionViewCell else {
                return .init()
            }
            self.cellDataArray[indexPath.item].indexPath = indexPath
            cell.configure(self.cellDataArray[indexPath.item])
            cell.delegate = self

            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameMatchingTagCollectionViewCell", for: indexPath) as? TagCollectionViewCell else {
                return .init()
            }
            cell.configure(self.tagCellDataArray[indexPath.item], self.resetButtonIsSelected ?? false)
            cell.delegate = self

            return cell
        }
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
    func cellTapped(_ cell: CalendarCollectionViewCell) {
        guard let indexPath = calendarCollectionView.indexPath(for: cell) else { return }
        if cellDataArray[indexPath.item].stackviewTappedBool == false {
            cellDataArray[indexPath.item].stackviewTappedBool = true
        } else {
            self.cellDataArray[indexPath.item].stackviewTappedBool = false
        }
        self.calendarCollectionView.reloadData()
    }
}

extension GameMatchingViewController: TagCollectionViewCellTapped {
    func cellButtonTapped(_ button: RoundButton) {
        self.resetButtonIsSelected = false
        guard let buttonTitle = button.currentTitle else { return }
        if button.isSelected {
            self.tappedTagCellData.append(buttonTitle)
        } else {
            guard let buttonTitleIndex = self.tappedTagCellData.firstIndex(of: buttonTitle) else { return }
            self.tappedTagCellData.remove(at: buttonTitleIndex)
        }

        if !self.tappedTagCellData.isEmpty {
            self.tagCollectionViewCellIsSelectedViewSetting()
        } else {
            self.tagCollectionViewCellIsNotSelectedViewSetting()
        }
    }
}
