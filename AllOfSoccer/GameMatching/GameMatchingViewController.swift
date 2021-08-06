//
//  GameMatchingViewController.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/07/04.
//

import UIKit
import FSCalendar
import SnapKit

enum MatchingMode {
    case teamMatching
    case manMatching
}

enum CollecionviewType: String {
    case HorizontalCalendarView
    case FilterTagCollectionView
}

class GameMatchingViewController: UIViewController {

    // MARK: - MatchingModeButton Variable
    @IBOutlet private weak var teamMatchButton: SelectTableButton!
    @IBOutlet private weak var manMatchButton: SelectTableButton!
    @IBOutlet private weak var selectedLineCenterConstraint: NSLayoutConstraint!

    // MARK: - HorizontalCalendar Variable
    private var selectedDate: [String] = []
    private var weeks: [String] = ["월","화","수","목","금","토","일"]
    private var horizontalCalendarCellData
        : [HorizontalCalendarModel] = []

    @IBOutlet private weak var horizontalCalendarView: UICollectionView!

    // MARK: - FilterTagCollectionView Variable
    private var tagTitles: [String] = ["장소", "시간대", "경기", "참가비", "실력", "11111", "2222222", "333333"]
    private var tagCellData: [FilterTagModel] = []
    private var filterTagCellData: [String] = []

    @IBOutlet private weak var filterTagCollectionView: UICollectionView!
    @IBOutlet private weak var resetButtonView: UIView!
    @IBOutlet private weak var tagCollectionViewConstraint: NSLayoutConstraint!

    // MARK: - NormalCalendarView Variable
    private let dateFormatter = DateFormatter()
    private var currentPage: Date?
    private lazy var normalCalendarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private var calendarView = FSCalendar()
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
    private lazy var calendarBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        return view
    }()

    @IBOutlet private weak var monthButton: UIButton!

    // MARK: - TableViewFilterView Variable
    private var tableViewFilterView = TableViewFilterView()
    private var sortMode = SortMode.distance
    private lazy var filterBackGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        return view
    }()

    @IBOutlet private weak var tableViewFilterButton: UIButton!

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
        self.calendarBackgroundView.isHidden = false
        self.normalCalendarView.isHidden = false
    }

    @IBAction private func resetTagButtonTouchUp(_ sender: UIButton) {
        self.filterTagCellData.removeAll()
        self.filterTagCollectionView.reloadData()
        self.tagCollectionViewCellIsNotSelectedViewSetting()
    }

    @IBAction func tableViewSortingButtonTouchUp(_ sender: UIButton) {
        self.filterBackGroundView.isHidden = false
        self.tableViewFilterView.isHidden = false
    }

    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupHorizontalCalendarView()
        setupNormalCalendarView()
        setupFilterTagCollectionView()
        setupTableViewFilterView()
    }

    // MARK: - Setup View
    private func setupHorizontalCalendarView() {
        self.horizontalCalendarView.delegate = self
        self.horizontalCalendarView.dataSource = self

        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.minimumInteritemSpacing = 15
        flowlayout.minimumLineSpacing = 10
        flowlayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowlayout.scrollDirection = .horizontal

        let itemWidth = (self.horizontalCalendarView.frame.width - (15*6)) / 7
        flowlayout.itemSize = CGSize(width: itemWidth, height: 66)
        self.horizontalCalendarView.collectionViewLayout = flowlayout

        let dateRange = 1000
        for nextDay in 0...dateRange {
            var cellData = HorizontalCalendarModel()
            cellData.date = makeDate(nextDay)
            cellData.dayOfTheWeek = makeDayOfTheWeek(nextDay)
            self.horizontalCalendarCellData.append(cellData)
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
        self.calendarBackgroundView.isHidden = true
        self.normalCalendarView.isHidden = true

        self.calendarButton.addTarget(self, action: #selector(calendarButtonTouchUp), for: .touchUpInside)
        self.calendarPrevButton.addTarget(self, action: #selector(monthBackButtonTouchUp), for: .touchUpInside)
        self.calendarNextButton.addTarget(self, action: #selector(monthNextButtonTouchUp), for: .touchUpInside)
    }

    private func setupFilterTagCollectionView() {
        self.filterTagCollectionView.delegate = self
        self.filterTagCollectionView.dataSource = self
        self.filterTagCollectionView.allowsMultipleSelection = true

        let tagCollectionViewLayout = UICollectionViewFlowLayout()
        tagCollectionViewLayout.estimatedItemSize = CGSize(width: 500, height: 28)
        tagCollectionViewLayout.minimumInteritemSpacing = 6
        tagCollectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        tagCollectionViewLayout.scrollDirection = .horizontal
        self.filterTagCollectionView.collectionViewLayout = tagCollectionViewLayout

        self.tagCollectionViewConstraint.constant = -(self.resetButtonView.frame.width)
        self.resetButtonView.isHidden = true

        for tagCellTitle in self.tagTitles {
            var tagCellData = FilterTagModel()
            tagCellData.title = tagCellTitle
            self.tagCellData.append(tagCellData)
        }
    }

    private func setupTableViewFilterView() {

        self.tableViewFilterButton.setTitle(self.sortMode.sortModeTitle, for: .normal)

        self.view.addSubview(self.filterBackGroundView)
        self.filterBackGroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.filterBackGroundView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.filterBackGroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.filterBackGroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.filterBackGroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])

        self.filterBackGroundView.addSubview(self.tableViewFilterView)
        self.tableViewFilterView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableViewFilterView.widthAnchor.constraint(equalToConstant: 315),
            self.tableViewFilterView.heightAnchor.constraint(equalToConstant: 271),
            self.tableViewFilterView.centerXAnchor.constraint(equalTo: self.calendarBackgroundView.centerXAnchor),
            self.tableViewFilterView.centerXAnchor.constraint(equalTo: self.calendarBackgroundView.centerXAnchor),
            self.tableViewFilterView.centerYAnchor.constraint(equalTo: self.calendarBackgroundView.centerYAnchor)
        ])

        self.tableViewFilterView.delegate = self
        self.filterBackGroundView.isHidden = true
        self.tableViewFilterView.isHidden = true
    }

    private func makeDate(_ nextDay: Int) -> String? {
        let calendar = Calendar.current
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        guard let changedDate = calendar.date(byAdding: .day, value: nextDay, to: currentDate) else { return nil }
        let chagedDateDay = calendar.dateComponents([.day], from: changedDate).day
        if chagedDateDay == 1 {
            dateFormatter.dateFormat = "M/d"
        } else {
            dateFormatter.dateFormat = "d"
        }
        let dateString = dateFormatter.string(from: changedDate)
        return dateString
    }

    private func makeDayOfTheWeek(_ nextDay: Int) -> Int? {
        let calendar = Calendar.current
        let currentDate = Date()
        guard let chagedDate = calendar.date(byAdding: .day, value: nextDay, to: currentDate) else { return nil}
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
        self.calendarBackgroundView.isHidden = true
        self.normalCalendarView.isHidden = true
    }

    @objc private func monthBackButtonTouchUp() {
        moveCurrentPage(moveUp: false)
    }

    @objc private func monthNextButtonTouchUp() {
        moveCurrentPage(moveUp: true)
    }

    private func moveCurrentPage(moveUp: Bool) {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = moveUp ? 1 : -1

        self.currentPage = calendar.date(byAdding: dateComponents, to: self.currentPage ?? Date())
        guard let currentPage = self .currentPage else { return }
        self.calendarView.setCurrentPage(currentPage, animated: true)
    }

    private func tagCollectionViewCellIsNotSelectedViewSetting() {
        let resetButtonViewWidth = self.resetButtonView.frame.width
        UIView.animate(withDuration: 0.05) { [weak self] in
            self?.tagCollectionViewConstraint.constant = -(resetButtonViewWidth)
            self?.resetButtonView.isHidden = true
            self?.view.layoutIfNeeded()
        }
    }

    private func tagCollectionViewCellIsSelectedViewSetting() {
        UIView.animate(withDuration: 0.05) { [weak self] in
            self?.tagCollectionViewConstraint.constant = 0
            self?.resetButtonView.isHidden = false
            self?.view.layoutIfNeeded()
        }
    }

    private func normalCalendarViewConstraint() {
        // 향후 사용할 예정
        //        guard let tabBarController = self.tabBarController else { return }
        //        if tabBarController.view.subviews.contains(calendarBackGroundView) == false {
        //
        //        }
        self.view.addSubview(calendarBackgroundView)
        self.calendarBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.calendarBackgroundView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            self.calendarBackgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            self.calendarBackgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            self.calendarBackgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
        ])

        self.calendarBackgroundView.addSubview(self.normalCalendarView)
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

// MARK: - CollectionViewDelegate
extension GameMatchingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if collectionView == self.horizontalCalendarView {
            // 데이터 처리
        } else if collectionView == self.filterTagCollectionView {
            // 데이터 처리
            guard let tagLabelTitle = self.tagCellData[indexPath.item].title else { return }
            self.filterTagCellData.append(tagLabelTitle)
            if !self.filterTagCellData.isEmpty {
                self.tagCollectionViewCellIsSelectedViewSetting()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == self.horizontalCalendarView {
            // 데이터 처리
        } else if collectionView == self.filterTagCollectionView {
            // 데이터 처리
            guard let tagLabelTitle = self.tagCellData[indexPath.item].title else { return }
            guard let indexTagLabelTitle = filterTagCellData.firstIndex(of: tagLabelTitle) else { return }
            self.filterTagCellData.remove(at: indexTagLabelTitle)
            if self.filterTagCellData.isEmpty {
                self.tagCollectionViewCellIsNotSelectedViewSetting()
            }
        }
    }
}

// MARK: - CollectionViewDataSource
extension GameMatchingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.horizontalCalendarView {
            return self.horizontalCalendarCellData.count
        } else {
            return self.tagCellData.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.horizontalCalendarView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalCalendarCollectionViewCell", for: indexPath) as? HorizontalCalendarCollectionViewCell else {
                return .init()
            }
            cell.configure(self.horizontalCalendarCellData[indexPath.item])

            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterTagCollectionViewCell", for: indexPath) as? FilterTagCollectionViewCell else {
                return .init()
            }
            cell.configure(self.tagCellData[indexPath.item])

            return cell
        }
    }
}

// MARK: - CollectionViewFlowLayout
extension GameMatchingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
}

// MARK: - FSCollectionViewDelegate
extension GameMatchingViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let stringDate = self.dateFormatter.string(from: date)
        self.selectedDate.append(stringDate)
        let countOfSeletedDate = self.selectedDate.count
        let buttonTitle = self.selectedDate.isEmpty ? "선택해주세요" : "선택 적용하기 (\(countOfSeletedDate))"
        self.calendarButton.setTitle(buttonTitle, for: .normal)
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let stringDate = self.dateFormatter.string(from: date)
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

// MARK: - FSCollectionViewDataSource
extension GameMatchingViewController: FSCalendarDataSource {

}

// MARK: -
extension GameMatchingViewController: TableViewFilterViewDelegate {
    func finishButtonDidSelected(_ tableViewFilterView: TableViewFilterView, sortMode: SortMode) {
        self.filterBackGroundView.isHidden = true
        self.tableViewFilterView.isHidden = true
        self.sortMode = sortMode
        self.tableViewFilterButton.setTitle(self.sortMode.sortModeTitle, for: .normal)
    }
}

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
