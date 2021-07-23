//
//  GameMatchingViewController.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/07/04.
//

import UIKit

class GameMatchingViewController: UIViewController {
    private var cellDataArray
        : [CellData] = []

    @IBOutlet private weak var teamMatchButton: SelectTableButton!
    @IBOutlet private weak var manMatchButton: SelectTableButton!
    @IBOutlet private weak var selectedLineCenterConstraint: NSLayoutConstraint!
    @IBOutlet private weak var monthButton: UIButton!
    @IBOutlet private weak var
        calendarCollectionView: UICollectionView!

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

    override func viewDidLoad() {
        super.viewDidLoad()

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

        let dateRange = 1000
        for nextDay in 0...dateRange {
            var cellData = CellData()
            cellData.date = makeDate(nextDay)
            cellData.dayOfTheWeek = makeDayOfTheWeek(nextDay)
            cellData.stackviewTappedBool = false
            self.cellDataArray.append(cellData)
        }
        self.monthButton.setTitle(makeMonthButtonText(), for: .normal)
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
        self.cellDataArray[indexPath.item].indexPath = indexPath
        cell.configure(self.cellDataArray[indexPath.item])
        cell.delegate = self

        return cell
    }
}

extension GameMatchingViewController: ViewTappedDelegate {
    func viewTapped(_ cell: CalendarCollectionViewCell) {
        guard let indexPath = self.calendarCollectionView.indexPath(for: cell) else { return }
        if self.cellDataArray[indexPath.item].stackviewTappedBool == false {
            self.cellDataArray[indexPath.item].stackviewTappedBool = true
        } else {
            self.cellDataArray[indexPath.item].stackviewTappedBool = false
        }
        self.calendarCollectionView.reloadData()
    }
}
