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

    // MARK: - MatchingModeButton Variable
    @IBOutlet private weak var teamMatchButton: SelectTableButton!
    @IBOutlet private weak var manMatchButton: SelectTableButton!
    @IBOutlet private weak var selectedLineCenterConstraint: NSLayoutConstraint!


    // MARK: - HorizontalCalendar Variable
    private var selectedDate: [String] = []
    private var weeks: [String] = ["월","화","수","목","금","토","일"]
    private var components = DateComponents()
    private let now = Date()
    private let dateFormatter = DateFormatter()
    private var calendarCellData
        : [CalendarCellData] = []
    private var currentPage: Date?

    // MARK: - FilterTagCollectionView Variable
    private var tagTitles: [String] = ["장소", "시간대", "경기", "참가비", "실력", "11111", "2222222", "333333"]
    private var tagCellData: [TagCellData] = []
    private var filteringTagCellData: [String] = []
    private var resetButtonIsSelected: Bool?
    private var sortMode = SortMode.distance
    private lazy var today: Date = {
        return Date()
    }()

    // MARK: - NormalCalendarView Variable
    private lazy var normalCalendarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private lazy var calendarView = FSCalendar()

    private lazy var calendarButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 236.0/255.0, green: 95.0/255.0, blue: 95.0/255.0, alpha: 1.0)
        button.setTitle("선택해주세요", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return button
    }()

    private lazy var calendarPrevButton: UIButton = {
        let button = UIButton()
        let buttonImage = UIImage(systemName: "arrowtriangle.left.fill")
        button.setImage(buttonImage, for: .normal)
        button.tintColor = UIColor(red: 194.0/255.0, green: 194.0/255.0, blue: 194.0/255.0, alpha: 1.0)
        return button
    }()

    private lazy var calendarNextButton: UIButton = {
        let button = UIButton()
        let buttonImage = UIImage(systemName: "arrowtriangle.right.fill")
        button.setImage(buttonImage, for: .normal)
        button.tintColor = UIColor(red: 194.0/255.0, green: 194.0/255.0, blue: 194.0/255.0, alpha: 1.0)
        return button
    }()

    private lazy var calendarBackGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        return view
    }()

    // MARK: - TableViewFilterView Variable
    private var tableViewFilterView = TableViewFilterView()
    @IBOutlet private weak var monthButton: UIButton!
    @IBOutlet private weak var calendarCollectionView: UICollectionView!
    @IBOutlet private weak var tagCollectionView: UICollectionView!
    @IBOutlet private weak var refreshButtonView: UIView!
    @IBOutlet private weak var tagCollectionViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableViewSortingButton: UIButton!
    private lazy var filterBackGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        return view
    }()

    // MARK: - MatchingModeButtonAction
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

    // MARK: - CalendarMonthButtonAction
    @IBAction func monthButtonTouchUp(_ sender: UIButton) {
        self.calendarBackGroundView.isHidden = false
        self.normalCalendarView.isHidden = false
    }

    @IBAction private func resetTagCollectionView(_ sender: UIButton) {
        self.resetButtonIsSelected = true
        self.filteringTagCellData.removeAll()
        self.tagCellData = self.tagCellData.map { (cell) -> TagCellData in
            var cell = cell
            cell.tagCellIsSelected = false
            return cell
        }
        self.tagCollectionView.reloadData()
        self.tagCollectionViewCellIsNotSelectedViewSetting()
    }

    @IBAction func tableViewSortingButtonTouchUp(_ sender: UIButton) {
        self.calendarBackGroundView.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCalendarCollectionView()
        setupNormalCalendarView()
        setupTagCollectionView()
        setupTableViewFilterView()
    }

    // MARK: - Setup View
    private func setupCalendarCollectionView() {
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

        let dateRange = 1000
        for nextDay in 0...dateRange {
            var cellData = CalendarCellData()
            cellData.date = makeDate(nextDay)
            cellData.dayOfTheWeek = makeDayOfTheWeek(nextDay)
            cellData.stackviewTappedBool = false
            self.calendarCellData.append(cellData)
        }
        self.monthButton.setTitle(makeMonthButtonText(), for: .normal)
    }

    private func setupNormalCalendarView() {

        normalCalendarViewConstraint()

        self.calendarView.appearance.titleWeekendColor = UIColor.red
        self.calendarView.appearance.selectionColor = UIColor.black
        self.calendarView.appearance.todayColor = nil
        self.calendarView.appearance.titleTodayColor = nil

        self.calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        self.calendarView.appearance.headerDateFormat = "M월"
        self.calendarView.appearance.headerTitleColor = .black
        self.calendarView.appearance.headerTitleFont = UIFont.systemFont(ofSize: 20, weight: .bold)

        self.calendarView.locale = Locale(identifier: "ko_KR")
        self.calendarView.calendarWeekdayView.weekdayLabels[0].text = "일"
        self.calendarView.calendarWeekdayView.weekdayLabels[1].text = "월"
        self.calendarView.calendarWeekdayView.weekdayLabels[2].text = "화"
        self.calendarView.calendarWeekdayView.weekdayLabels[3].text = "수"
        self.calendarView.calendarWeekdayView.weekdayLabels[4].text = "목"
        self.calendarView.calendarWeekdayView.weekdayLabels[5].text = "금"
        self.calendarView.calendarWeekdayView.weekdayLabels[6].text = "토"

        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        self.calendarView.allowsMultipleSelection = true
        self.calendarBackGroundView.isHidden = true
        self.normalCalendarView.isHidden = true

        self.calendarButton.addTarget(self, action: #selector(calendarButtonTouchUp), for: .touchUpInside)
        self.calendarPrevButton.addTarget(self, action: #selector(monthBackButtonPressed), for: .touchUpInside)
        self.calendarNextButton.addTarget(self, action: #selector(monthNextButtonPressed), for: .touchUpInside)
    }

    private func setupTagCollectionView() {
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

        for tagCellTitle in self.tagTitles {
            var tagCellData = TagCellData()
            tagCellData.tagCellTitle = tagCellTitle
            tagCellData.tagCellIsSelected = false
            self.tagCellData.append(tagCellData)
        }
    }

    private func setupTableViewFilterView() {

        self.tableViewSortingButton.setTitle(self.sortMode.sortModeTitle, for: .normal)

        self.view.addSubview(filterBackGroundView)
        self.filterBackGroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.filterBackGroundView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.filterBackGroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.filterBackGroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.filterBackGroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])

        self.filterBackGroundView.addSubview(tableViewFilterView)
        self.tableViewFilterView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableViewFilterView.widthAnchor.constraint(equalToConstant: 315),
            self.tableViewFilterView.heightAnchor.constraint(equalToConstant: 271),
            self.tableViewFilterView.centerXAnchor.constraint(equalTo: self.calendarBackGroundView.centerXAnchor),
            self.tableViewFilterView.centerXAnchor.constraint(equalTo: self.calendarBackGroundView.centerXAnchor),
            self.tableViewFilterView.centerYAnchor.constraint(equalTo: self.calendarBackGroundView.centerYAnchor)
        ])

        self.tableViewFilterView.delegate = self
        self.filterBackGroundView.isHidden = true
    }

    private func makeDate(_ plusValue: Int) -> String? {
        let calendar = Calendar.current
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        guard let chagedDate = calendar.date(byAdding: .day, value: plusValue, to: currentDate) else { return nil }
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

    @objc private func calendarButtonTouchUp() {
        self.calendarBackGroundView.isHidden = true
        self.normalCalendarView.isHidden = true
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

    private func tagCollectionViewCellIsNotSelectedViewSetting() {
        self.tagCollectionViewConstraint.constant = -(refreshButtonView.frame.width)
        self.refreshButtonView.isHidden = true
    }

    private func tagCollectionViewCellIsSelectedViewSetting() {
        self.tagCollectionViewConstraint.constant = 0
        self.refreshButtonView.isHidden = false
    }

    private func normalCalendarViewConstraint() {
        //        guard let tabBarController = self.tabBarController else { return }
        //        if tabBarController.view.subviews.contains(calendarBackGroundView) == false {
        //
        //        }
        self.view.addSubview(calendarBackGroundView)
        self.calendarBackGroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.calendarBackGroundView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            self.calendarBackGroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            self.calendarBackGroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            self.calendarBackGroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
        ])

        self.calendarBackGroundView.addSubview(self.normalCalendarView)
        self.normalCalendarView.snp.makeConstraints { (make) in
            make.width.equalTo(315)
            make.height.equalTo(406)
            make.center.equalTo(self.view)
        }

        self.normalCalendarView.addSubview(calendarButton)
        self.calendarButton.snp.makeConstraints { (make) in
            make.width.equalTo(normalCalendarView)
            make.height.equalTo(63)
            make.bottom.equalTo(normalCalendarView)
        }

        self.normalCalendarView.addSubview(calendarView)
        self.calendarView.snp.makeConstraints { (make) in
            make.top.equalTo(normalCalendarView)
            make.bottom.equalTo(calendarButton.snp.top)
            make.width.equalTo(normalCalendarView)
        }

        self.calendarView.addSubview(calendarPrevButton)
        self.calendarPrevButton.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.top).offset(25)
            make.left.equalTo(calendarView.snp.left).offset(25)
            make.width.equalTo(14)
            make.height.equalTo(14)
        }

        self.calendarView.addSubview(calendarNextButton)
        self.calendarNextButton.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.top).offset(25)
            make.right.equalTo(calendarView.snp.right).offset(-25)
            make.width.equalTo(14)
            make.height.equalTo(14)
        }
    }
}

extension GameMatchingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension GameMatchingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.calendarCollectionView {
            return self.calendarCellData.count
        } else {
            return self.tagCellData.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.calendarCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCollectionViewCell", for: indexPath) as? CalendarCollectionViewCell else {
                return .init()
            }
            self.calendarCellData[indexPath.item].indexPath = indexPath
            cell.configure(self.calendarCellData[indexPath.item])
            cell.delegate = self

            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameMatchingTagCollectionViewCell", for: indexPath) as? TagCollectionViewCell else {
                return .init()
            }

            cell.configure(self.tagCellData[indexPath.item], self.resetButtonIsSelected ?? false)
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
        let buttonTitle = self.selectedDate.isEmpty ? "선택해주세요" : "선택 적용하기 (\(countOfSeletedDate))"
        self.calendarButton.setTitle(buttonTitle, for: .normal)
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let stringDate = dateFormatter.string(from: date)
        guard let indexOfStringDate = selectedDate.firstIndex(of: stringDate) else { return }
        self.selectedDate.remove(at: indexOfStringDate)
        let countOfSeletedDate = self.selectedDate.count
        let buttonTitle = self.selectedDate.isEmpty ? "선택해주세요" : "선택 적용하기 (\(countOfSeletedDate))"
        self.calendarButton.setTitle(buttonTitle, for: .normal)
    }

    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
}

extension GameMatchingViewController: FSCalendarDataSource {

}

extension GameMatchingViewController: CalendarCellTappedDelegate {
    func cellTapped(_ cell: CalendarCollectionViewCell) {
        guard let indexPath = calendarCollectionView.indexPath(for: cell) else { return }
        if calendarCellData[indexPath.item].stackviewTappedBool == false {
            calendarCellData[indexPath.item].stackviewTappedBool = true
        } else {
            self.calendarCellData[indexPath.item].stackviewTappedBool = false
        }
        self.calendarCollectionView.reloadData()
    }
}

extension GameMatchingViewController: TagCollectionViewCellTapped {
    func cellTapped(_ cell: TagCollectionViewCell) {
        self.resetButtonIsSelected = false
        guard let indexPath = tagCollectionView.indexPath(for: cell) else { return }
        guard let buttonTitle = cell.tagButton.currentTitle else { return }

        if self.tagCellData[indexPath.item].tagCellIsSelected == false {
            self.tagCellData[indexPath.item].tagCellIsSelected = true
        } else {
            self.tagCellData[indexPath.item].tagCellIsSelected = false
        }
        self.tagCollectionView.reloadData()

        if !self.filteringTagCellData.isEmpty {
            self.tagCollectionViewCellIsSelectedViewSetting()
        } else {
            self.tagCollectionViewCellIsNotSelectedViewSetting()
        }

        if cell.tagButton.isSelected {
            self.filteringTagCellData.append(buttonTitle)
        } else {
            guard let buttonTitleIndex = self.filteringTagCellData.firstIndex(of: buttonTitle) else { return }
            self.filteringTagCellData.remove(at: buttonTitleIndex)
        }
    }
}

extension GameMatchingViewController: TableViewSortingViewDelegate {
    func sortingFinishButtonTapped(button: UIButton, sortMode: SortMode) {
        self.calendarBackGroundView.isHidden = true
        self.sortMode = sortMode
        self.tableViewSortingButton.setTitle(self.sortMode.sortModeTitle, for: .normal)
    }
}

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
