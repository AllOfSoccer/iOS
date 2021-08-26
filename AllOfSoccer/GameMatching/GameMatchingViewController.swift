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

enum FilterType: CaseIterable {
    case location
    case time
    case game
    case cost
    case level

    var tagTitle: String {
        switch self {
        case .location: return "장소"
        case .time: return "시간대"
        case .game: return "경기"
        case .cost: return "참가비"
        case .level: return "실력"
        }
    }

    var filterList: [String] {
        switch self {
        case .location: return ["서울", "경기-북부", "경기-남부", "인천/부천", "기타지역"]
        case .time: return ["10:00", "11:00", "12:00"]
        case .game: return ["11"]
        case .cost: return ["12312312312", "ㅁㄴㅇㅁㄴㅇㅁㅇㄴ"]
        case .level: return ["상", "중", "하"]
        }
    }
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
    
    // MARK: - FilterDetailView
    private let filterDetailView = FilterDetailView()
    private var bottomConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private lazy var filterDetailBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        return view
    }()

    // MARK: - NoticeTableView Variable
    @IBOutlet private weak var noticeTableView: UITableView!

    // MARK: - FilterTagCollectionView Variable
    private var tagCellModel: [FilterTagModel] = []
    private var didSelectedFilterList: [String: FilterType] = [:]

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
    private lazy var filterBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        return view
    }()

    @IBOutlet private weak var tableViewFilterButton: UIButton!

    // MARK: - RecruitmentButtonAction
    @IBOutlet private weak var recruitmentButton: RoundButton!
    @IBOutlet private weak var manRecruitmentButton: RoundButton!
    @IBOutlet private weak var teamRecruitmentButton: RoundButton!

    private var recruitmentBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        return view
    }()

    // MARK: - MatchingModeButtonAction
    @IBAction private func teamMatchButtonTouchUp(_ sender: Any) {
        self.teamMatchButton.isSelected = true
        self.manMatchButton.isSelected = false

        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.selectedLineCenterConstraint.constant = 0
            self?.view.layoutIfNeeded()
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
        appearNormalCalendarView()
    }

    @IBAction private func resetTagButtonTouchUp(_ sender: UIButton) {
        self.didSelectedFilterList.removeAll()
        self.filterDetailView.didSelectedFilterList.removeAll()
        self.filterTagCollectionView.reloadData()
        self.tagCollectionViewCellIsNotSelectedViewSetting()
    }

    @IBAction func tableViewSortingButtonTouchUp(_ sender: UIButton) {
        appearTableViewFilterView()
    }

    // MARK: - RecruitmentButtonAction
    @IBAction private func recruitmentButtonTouchUp(_ sender: UIButton) {
        self.didSelectedRecruitmentButtonSetting(sender.isSelected)
    }

    @IBAction func teamRecruitmentButtonTouchUp(_ sender: UIButton) {

    }

    @IBAction func manRecruitmentButtonTouchUp(_ sender: UIButton) {
        guard let recruitmentNavigationController = UIStoryboard.init(name: "Recruitment", bundle: nil).instantiateViewController(identifier: "RecruitmentNavigationController") as? UINavigationController  else { return }

        recruitmentNavigationController.modalPresentationStyle = .fullScreen
        self.navigationController?.present(recruitmentNavigationController, animated: true, completion: nil)
    }

    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupHorizontalCalendarView()
        setupNormalCalendarView()
        setupFilterTagCollectionView()
        setupTableViewFilterView()
        setupFilterDetailView()
        setupNoticeTableView()

        setupRecruitmentButton()
        setupRecruitmentButtonConstraint()
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

        for filterType in FilterType.allCases {
            let tagCellData = FilterTagModel(filterType: filterType)
            self.tagCellModel.append(tagCellData)
        }
        print("ddd")
    }

    private func setupTableViewFilterView() {
        self.tableViewFilterView.delegate = self
    }

    private func setupFilterDetailView() {
        self.filterDetailView.delegate = self

        guard let tabbar = self.tabBarController else { return }
        tabbar.view.addSubview(self.filterDetailBackgroundView)
        self.filterDetailBackgroundView.addSubview(self.filterDetailView)
        let itemHeight = 244

        self.filterDetailBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.filterDetailBackgroundView.leadingAnchor.constraint(equalTo: tabbar.view.leadingAnchor, constant: 0),
            self.filterDetailBackgroundView.topAnchor.constraint(equalTo: tabbar.view.topAnchor, constant: 0),
            self.filterDetailBackgroundView.bottomAnchor.constraint(equalTo: tabbar.view.bottomAnchor, constant: 0),
            self.filterDetailBackgroundView.trailingAnchor.constraint(equalTo: tabbar.view.trailingAnchor, constant: 0)
        ])

        self.filterDetailView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.filterDetailView.leadingAnchor.constraint(equalTo: self.filterDetailBackgroundView.leadingAnchor, constant: 0),
            self.filterDetailView.trailingAnchor.constraint(equalTo: self.filterDetailBackgroundView.trailingAnchor, constant: 0),
            self.filterDetailView.heightAnchor.constraint(equalToConstant: CGFloat(itemHeight)),
            self.filterDetailView.bottomAnchor.constraint(equalTo: self.filterDetailBackgroundView.bottomAnchor, constant: CGFloat(itemHeight))
        ])

        self.filterDetailView.isHidden = true
        self.filterDetailBackgroundView.isHidden = true
    }

    private func setupNoticeTableView() {
        self.noticeTableView.delegate = self
        self.noticeTableView.dataSource = self
    }

    private func setupRecruitmentButton() {
        self.recruitmentButton.setImage(UIImage(systemName: "plus"), for: .normal)
        self.recruitmentButton.setImage(UIImage(systemName: "xmark"), for: .selected)
        self.recruitmentButton.setBackgroundColor(UIColor(red: 236/255, green: 95/255, blue: 95/255, alpha: 1), for: .normal)
        self.recruitmentButton.setBackgroundColor(.white, for: .selected)
        self.recruitmentButton.clipsToBounds = true
    }

    private func setupRecruitmentButtonConstraint() {
        guard let tabbar = self.tabBarController else { return }
        tabbar.view.addSubview(self.recruitmentButton)
        self.recruitmentButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.recruitmentButton.bottomAnchor.constraint(equalTo: tabbar.view.bottomAnchor, constant: -100),
            self.recruitmentButton.trailingAnchor.constraint(equalTo: tabbar.view.trailingAnchor, constant: -20)
        ])

        tabbar.view.addSubview(self.recruitmentBackgroundView)
        self.recruitmentBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.recruitmentBackgroundView.topAnchor.constraint(equalTo: tabbar.view.topAnchor, constant: 0),
            self.recruitmentBackgroundView.leadingAnchor.constraint(equalTo: tabbar.view.leadingAnchor, constant: 0),
            self.recruitmentBackgroundView.trailingAnchor.constraint(equalTo: tabbar.view.trailingAnchor, constant: 0),
            self.recruitmentBackgroundView.bottomAnchor.constraint(equalTo: tabbar.view.bottomAnchor, constant: 0)
        ])

        tabbar.view.addSubview(self.manRecruitmentButton)
        self.manRecruitmentButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.manRecruitmentButton.bottomAnchor.constraint(equalTo: tabbar.view.bottomAnchor, constant: -105),
            self.manRecruitmentButton.trailingAnchor.constraint(equalTo: tabbar.view.trailingAnchor, constant: -25)
        ])

        tabbar.view.addSubview(self.teamRecruitmentButton)
        self.teamRecruitmentButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.teamRecruitmentButton.bottomAnchor.constraint(equalTo: tabbar.view.bottomAnchor, constant: -105),
            self.teamRecruitmentButton.trailingAnchor.constraint(equalTo: tabbar.view.trailingAnchor, constant: -25)
        ])

        self.recruitmentBackgroundView.isHidden = true
        self.manRecruitmentButton.isHidden = true
        self.teamRecruitmentButton.isHidden = true
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
        self.calendarBackgroundView.removeFromSuperview()
        self.normalCalendarView.removeFromSuperview()
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
        guard let currentPage = self.currentPage else { return }
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

    private func appearTableViewFilterView() {
        self.tableViewFilterButton.setTitle(self.sortMode.sortModeTitle, for: .normal)

        guard let tabbar = self.tabBarController else { return }
        tabbar.view.addSubview(self.filterBackgroundView)
        self.filterBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.filterBackgroundView.topAnchor.constraint(equalTo: tabbar.view.topAnchor),
            self.filterBackgroundView.bottomAnchor.constraint(equalTo: tabbar.view.bottomAnchor),
            self.filterBackgroundView.leadingAnchor.constraint(equalTo: tabbar.view.leadingAnchor),
            self.filterBackgroundView.trailingAnchor.constraint(equalTo: tabbar.view.trailingAnchor)
        ])

        self.filterBackgroundView.addSubview(self.tableViewFilterView)
        self.tableViewFilterView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableViewFilterView.widthAnchor.constraint(equalToConstant: 315),
            self.tableViewFilterView.heightAnchor.constraint(equalToConstant: 271),
            self.tableViewFilterView.centerXAnchor.constraint(equalTo: self.filterBackgroundView.centerXAnchor),
            self.tableViewFilterView.centerYAnchor.constraint(equalTo: self.filterBackgroundView.centerYAnchor)
        ])
    }

    private func appearNormalCalendarView() {
        guard let tabbar = self.tabBarController else { return }
        tabbar.view.addSubview(calendarBackgroundView)
        self.calendarBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.calendarBackgroundView.topAnchor.constraint(equalTo: tabbar.view.topAnchor, constant: 0),
            self.calendarBackgroundView.bottomAnchor.constraint(equalTo: tabbar.view.bottomAnchor, constant: 0),
            self.calendarBackgroundView.leadingAnchor.constraint(equalTo: tabbar.view.leadingAnchor, constant: 0),
            self.calendarBackgroundView.trailingAnchor.constraint(equalTo: tabbar.view.trailingAnchor, constant: 0)
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

    private func setupRecruitmentButtonIsSelected() {
        self.recruitmentBackgroundView.isHidden = false
        self.manRecruitmentButton.isHidden = false
        self.teamRecruitmentButton.isHidden = false

        self.manRecruitmentButton.translatesAutoresizingMaskIntoConstraints = true
        self.teamRecruitmentButton.translatesAutoresizingMaskIntoConstraints = true
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.manRecruitmentButton.frame = CGRect(x: self.manRecruitmentButton.frame.minX, y: self.recruitmentButton.frame.minY - self.manRecruitmentButton.frame.height - 16, width: self.manRecruitmentButton.frame.width, height: self.manRecruitmentButton.frame.height)
            self.teamRecruitmentButton.frame = CGRect(x: self.teamRecruitmentButton.frame.minX, y: self.recruitmentButton.frame.minY - self.manRecruitmentButton.frame.height - self.teamRecruitmentButton.frame.height - 32, width: self.manRecruitmentButton.frame.width, height: self.manRecruitmentButton.frame.height)
            self.view.layoutIfNeeded()
        }
        self.tabBarController?.view.insertSubview(self.recruitmentButton, at: self.tabBarController?.view.subviews.count ?? 0)
    }

    private func setupRecruitmentButtonIsDeSelected() {

        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }

            self.manRecruitmentButton.frame = CGRect(x: self.recruitmentButton.frame.minX + 5, y: self.recruitmentButton.frame.minY + 5, width: self.manRecruitmentButton.frame.width, height: self.manRecruitmentButton.frame.height)
            self.teamRecruitmentButton.frame = CGRect(x: self.recruitmentButton.frame.minX + 5, y: self.recruitmentButton.frame.minY + 5, width: self.teamRecruitmentButton.frame.width, height: self.teamRecruitmentButton.frame.height)
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.recruitmentBackgroundView.isHidden = true
            self.teamRecruitmentButton.isHidden = true
            self.manRecruitmentButton.isHidden = true
            self.tabBarController?.view.insertSubview(self.recruitmentButton, at: self.tabBarController?.view.subviews.count ?? 0)
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
            self.filterDetailView.filterType = self.tagCellModel[indexPath.item].filterType
            self.appearFilterDetailView()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == self.horizontalCalendarView {
            // 데이터 처리
        } else if collectionView == self.filterTagCollectionView {
            // 데이터 처리
        }
    }

    private func appearFilterDetailView() {
        self.filterDetailView.isHidden = false
        self.filterDetailBackgroundView.isHidden = false

        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            guard let tabbar = self.tabBarController else { return }
            self.filterDetailView.frame = CGRect(x: 0, y: tabbar.view.frame.height - 244, width: self.filterDetailView.frame.width, height: self.filterDetailView.frame.height)
            self.tabBarController?.view.layoutIfNeeded()
        }
    }

    private func didSelectedRecruitmentButtonSetting(_ isSelected: Bool) {
        if isSelected {
            setupRecruitmentButtonIsDeSelected()
            self.recruitmentButton.isSelected = false
            self.recruitmentButton.tintColor = .white
        } else {
            setupRecruitmentButtonIsSelected()
            self.recruitmentButton.isSelected = true
            self.recruitmentButton.tintColor = UIColor(red: 236.0/255.0, green: 95.0/255.0, blue: 95.0/255.0, alpha: 1.0)
        }
    }
}

// MARK: - CollectionViewDataSource
extension GameMatchingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.horizontalCalendarView {
            return self.horizontalCalendarCellData.count
        } else {
            return self.tagCellModel.count
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
            cell.configure(self.tagCellModel[indexPath.item], self.didSelectedFilterList)

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

// MARK: - TableViewDelegate
extension GameMatchingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let gameMatchingDetailViewController = UIStoryboard.init(name: "GameMatchingDetail", bundle: nil).instantiateViewController(withIdentifier: "GameMatchingDetailViewController") as? GameMatchingDetailViewController else { return }
        self.navigationController?.pushViewController(gameMatchingDetailViewController, animated: true)
    }
}

// MARK: - TableViewDatasource
extension GameMatchingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeTableViewCell", for: indexPath) as? NoticeTableViewCell else { return UITableViewCell() }
        return cell
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

// MARK: - TableViewFilterViewDelegate
extension GameMatchingViewController: TableViewFilterViewDelegate {
    func finishButtonDidSelected(_ tableViewFilterView: TableViewFilterView, sortMode: SortMode) {
        self.sortMode = sortMode
        self.tableViewFilterButton.setTitle(self.sortMode.sortModeTitle, for: .normal)
        self.tableViewFilterView.removeFromSuperview()
        self.filterBackgroundView.removeFromSuperview()
    }
}

// MARK: - FilterDetailViewDelegate
extension GameMatchingViewController: FilterDetailViewDelegate {
    func finishButtonDidSelected(_ detailView: FilterDetailView) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.filterDetailView.frame = CGRect(x: 0, y: 1000, width: self.filterDetailView.frame.width, height: self.filterDetailView.frame.height)
            self.tabBarController?.view.layoutIfNeeded()
        } completion: { _ in
            self.filterDetailBackgroundView.isHidden = true
            self.filterDetailView.isHidden = true

            self.didSelectedFilterList = detailView.didSelectedFilterList
            if self.didSelectedFilterList.isEmpty {
                self.tagCollectionViewCellIsNotSelectedViewSetting()
                self.filterTagCollectionView.reloadData()
            } else {
                self.tagCollectionViewCellIsSelectedViewSetting()
                self.filterTagCollectionView.reloadData()
            }
        }
    }

    func cancelButtonDidSelected(_ detailView: FilterDetailView) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.filterDetailView.frame = CGRect(x: 0, y: 1000, width: self.filterDetailView.frame.width, height: self.filterDetailView.frame.height)
            self.tabBarController?.view.layoutIfNeeded()
        } completion: { _ in
            self.filterDetailBackgroundView.isHidden = true
            self.filterDetailView.isHidden = true
        }
    }
}

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }

    subscript(safe bounds: Range<Int>) -> ArraySlice<Element>? {
        guard self.indices.lowerBound <= bounds.lowerBound && self.indices.upperBound >= bounds.upperBound else {
            return nil
        }
        return self[bounds]
    }

    subscript(safe bounds: ClosedRange<Int>) -> ArraySlice<Element>? {
        guard self.indices.lowerBound <= bounds.lowerBound && self.indices.upperBound >= bounds.upperBound else {
            return nil
        }
        return self[bounds]
    }
}
