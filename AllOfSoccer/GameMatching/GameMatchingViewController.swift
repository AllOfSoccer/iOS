//
//  GameMatchingViewController.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/07/04.
//

import UIKit
import FSCalendar

class GameMatchingViewController: UIViewController {
    private var weeks: [String] = ["월","화","수","목","금","토","일"]
    private var cal = Calendar.current
    private var components = DateComponents()
    private let now = Date()
    private let dateFormatter = DateFormatter()
    private var cellDataArray
        : [CellData] = []

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
        teamMatchButton.isSelected = false
        manMatchButton.isSelected = true

        let constant = manMatchButton.center.x - teamMatchButton.center.x

        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.selectedLineCenterConstraint.constant = constant
            self?.view.layoutIfNeeded()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self

        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.minimumInteritemSpacing = 15
        flowlayout.minimumLineSpacing = 10
        flowlayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowlayout.scrollDirection = .horizontal

        let itemWidth = (UIScreen.main.bounds.width - 84) / 10
        //        let itemWidth = ((UIScreen.main.bounds.width - (10 * (rowItemCount - 1))) / rowItemCount)
        flowlayout.itemSize = CGSize(width: itemWidth, height: 96)
        calendarCollectionView.collectionViewLayout = flowlayout

        dateFormatter.dateFormat = "M월"
        components.year = cal.component(.year, from: now)
        components.month = cal.component(.month, from: now)
        components.day = 1

        calculation()
    }

    private func calculation() {
        let firstDayOfMonth = cal.date(from: components)
        let firstWeekday = cal.component(.weekday, from: firstDayOfMonth!)
        let daysCountInMonth = cal.range(of: .day, in: .month, for: firstDayOfMonth!)!.count
        let weekdayAdding = 3 - firstWeekday

        self.monthButton.setTitle(dateFormatter.string(from: firstDayOfMonth!), for: .normal)

        for day in weekdayAdding...daysCountInMonth {
            if day < 1 {
                // 1보다 작을 경우는 비워줘야 하기 때문에 빈 값을 넣어준다.
                self.cellDataArray.append(CellData(weeks: weeks, day: " ", stackviewTappedBool: false))
            } else {
                self.cellDataArray.append(CellData(weeks: weeks, day: String(day), stackviewTappedBool: false))
            }
        }
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

extension GameMatchingViewController: ViewTappedDelegate {
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
