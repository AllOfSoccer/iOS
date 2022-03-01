//
//  GameMatchingViewModel.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2022/01/09.
//

import Foundation

class GameMatchingViewModel {

    // MARK: - selectedDateModel
    internal var selectedDate: [Date] = []

    internal private(set) var selectedString: Set<String> = []

    internal func updateSelectedDate(_ selectedDateString: String) {
        self.selectedString.insert(selectedDateString)
    }

    internal var formalSelectedDate: [Date] {
        return selectedDate
    }

    internal var formalStrSelectedDate: [String] {
        let strSelectedDate = self.selectedDate.map { self.changeDateFormat($0) }
        return strSelectedDate
    }

    internal func appendSelectedDate(_ dates: [Date]?, _ date: Date?) {
        if let dates = dates {
            self.selectedDate = dates
        } else if let date = date {
            self.selectedDate.append(date)
        }
    }

    internal func deleteSelectedDate(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"


        guard let indexOfDate = self.selectedDate.firstIndex(of: date) else { return }
        self.selectedDate.remove(at: indexOfDate)
    }

    // MARK: - horizontalCalendarModel
    private var horizontalCalendarModels: [HorizontalCalendarModel] = []

    internal var formalHorizontalCalendarModels: [HorizontalCalendarModel] {
        return horizontalCalendarModels
    }

    internal var formalStrHorizontalCalendarDates: [String] {
        let strHorizontalCalendarDates = self.horizontalCalendarModels.map { self.changeDateFormat($0.date) }

        return strHorizontalCalendarDates
    }

    internal var horizontalCount: Int {
        self.horizontalCalendarModels.count
    }

    internal func append(_ data: HorizontalCalendarModel) {
        self.horizontalCalendarModels.append(data)
    }

    internal func getSelectedDateModel(with indexpath: IndexPath) -> HorizontalCalendarModel {
        return self.horizontalCalendarModels[indexpath.item]
    }

    internal func makeMonthText(indexPath: IndexPath) -> String {
        let newIndexPathItem = makeNewIndexPathItem(indexPath: indexPath)
        let currentDate = self.horizontalCalendarModels[newIndexPathItem].date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월"
        let monthString = dateFormatter.string(from: currentDate)
        return monthString
    }

    private func makeNewIndexPathItem(indexPath: IndexPath) -> Int {
        var newIndexPathItem = indexPath.item
        if newIndexPathItem >= 6 {
            newIndexPathItem = newIndexPathItem - 6
        }
        return newIndexPathItem
    }
}

extension GameMatchingViewModel {
    private func changeDateFormat(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")

        let changedSelectedDate = dateFormatter.string(from: date)

        return changedSelectedDate
    }
}
