//
//  GameMatchingViewController.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/07/04.
//

import UIKit

class GameMatchingViewController: UIViewController {
    private var arrayToMakeCellData
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

        let itemWidth = (UIScreen.main.bounds.width - 84) / 9
        flowlayout.itemSize = CGSize(width: itemWidth, height: 96)
        calendarCollectionView.collectionViewLayout = flowlayout

        for plusValue in 0...1000 {
            var cellData = CellData()
            cellData.date = makeDate(plusValue)
            cellData.dayOfTheWeek = makeDayOfTheWeek(plusValue)
            cellData.stackviewTappedBool = false
            arrayToMakeCellData.append(cellData)
        }

        monthButton.setTitle(makeMonthButtonText(), for: .normal)
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

    private func makeDayOfTheWeek(_ plusValue: Int) -> Int {
        let calendar = Calendar.current
        let currentDate = Date()
        guard let chagedDate = calendar.date(byAdding: .day, value: plusValue, to: currentDate) else { return -1 }
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
        return self.arrayToMakeCellData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCollectionViewCell", for: indexPath) as? CalendarCollectionViewCell else {
            return .init()
        }

        arrayToMakeCellData[indexPath.item].indexPath = indexPath
        cell.configure(self.arrayToMakeCellData[indexPath.item])
        cell.delegate = self

        return cell
    }
}

extension GameMatchingViewController: ViewTappedDelegate {
    func viewTapped(_ cell: CalendarCollectionViewCell) {
        guard let indexPath = calendarCollectionView.indexPath(for: cell) else { return }
        if arrayToMakeCellData[indexPath.item].stackviewTappedBool == false {
            arrayToMakeCellData[indexPath.item].stackviewTappedBool = true
        } else {
            arrayToMakeCellData[indexPath.item].stackviewTappedBool = false
        }
        self.calendarCollectionView.reloadData()
    }
}
