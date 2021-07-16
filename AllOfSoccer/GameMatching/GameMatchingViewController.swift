//
//  GameMatchingViewController.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/07/04.
//

import UIKit
import FSCalendar

class GameMatchingViewController: UIViewController {
    private var rowItemCount: CGFloat = 7
    private var weeks: [String] = ["월","화","수","목","금","토","일"]
    private var cal = Calendar.current
    private var components = DateComponents()
    private var beforeComponents = DateComponents()
    private var days: [String] = []
    private var weekDays: [String] = []
    private let now = Date()
    private let dateFormatter = DateFormatter()

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

        let itemWidth = (UIScreen.main.bounds.width - 84) / 10
        //        let itemWidth = ((UIScreen.main.bounds.width - (10 * (rowItemCount - 1))) / rowItemCount)
        flowlayout.itemSize = CGSize(width: itemWidth, height: 96)
        calendarCollectionView.collectionViewLayout = flowlayout

        dateFormatter.dateFormat = "M월"
        components.year = cal.component(.year, from: now)
        components.month = cal.component(.month, from: now)
        components.day = cal.component(.day, from: now)

        beforeComponents.year = cal.component(.year, from: now)
        beforeComponents.month = cal.component(.month, from: now) - 1
        beforeComponents.day = 1

        calculation()

        makeWeeksDays()
    }

    private func calculation() {
        let firstDayOfMonth = cal.date(from: components)
        let firstWeekday = cal.component(.weekday, from: firstDayOfMonth!)
        let daysCountInMonth = cal.range(of: .day, in: .month, for: firstDayOfMonth!)!.count
        let weekdayAdding = 3 - firstWeekday

        self.monthButton.setTitle(dateFormatter.string(from: firstDayOfMonth!), for: .normal)
        self.days.removeAll()

        for day in weekdayAdding...daysCountInMonth {
            if day < 1 {
                // 1보다 작을 경우는 비워줘야 하기 때문에 빈 값을 넣어준다.
                self.days.append("")
            } else {
                self.days.append(String(day))
            }
        }
    }

    private func makeWeeksDays() {
        let nowDayOfMonth = cal.date(from: components)
        let nowWeekday = cal.component(.weekday, from: nowDayOfMonth!)
        let weekdayAdding = 3 - nowWeekday

        let beforeDay = cal.date(from: beforeComponents)
        // 이전달의 전체 요일을 담은 배열을 만들고 해당 배열의 끝에서 부족한 수만큼 땡겨와서 weekDays 배열에다가 값을 삽입해준다.

        self.weekDays.removeAll()

        for day in weekdayAdding...7 {
            print(day)
            if day < 1 {
                if (components.day ?? 0) - weekdayAdding >= 0 {
                    self.weekDays.append(String((components.day ?? 0) + day - 1))
                } else {
                    self.weekDays.append("")
                }
            } else {
                self.weekDays.append(String((components.day ?? 0) + day - 1))
            }
        }
    }
}

extension GameMatchingViewController: UICollectionViewDelegate {
}

extension GameMatchingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCollectionViewCell", for: indexPath) as? CalendarCollectionViewCell else {
            return .init()
        }
        cell.dayLabel.text = weeks[indexPath.item]
        cell.dateLabel.text = weekDays[indexPath.item]

        if indexPath.item % 7 == 6 {
            // 일요일
            cell.dayLabel.textColor = .red
            cell.dateLabel.textColor = .red
        } else if indexPath.item % 7 == 5 {
            // 토요일
            cell.dayLabel.textColor = .blue
            cell.dateLabel.textColor = .blue
        } else {
            // 평일
            cell.dayLabel.textColor = .black
            cell.dayLabel.textColor = .black
        }
        return cell
    }
}
