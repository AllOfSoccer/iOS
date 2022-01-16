//
//  GameMatchingViewModel.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2022/01/09.
//

import Foundation

class GameMatchingViewModel {

    private var selectedDayData: [HorizontalCalendarModel] = []

    internal var count: Int {
        self.selectedDayData.count
    }

    internal func append(_ data: HorizontalCalendarModel) {
        self.selectedDayData.append(data)
    }

    internal func getSelectedDay(with indexpath: IndexPath) -> HorizontalCalendarModel {
        return self.selectedDayData[indexpath.item]
    }

    internal func makeMonthButtonText(indexPath: IndexPath) -> String {
        let newIndexPathItem = makeNewIndexPathItem(indexPath: indexPath)
        let currentDate = self.selectedDayData[newIndexPathItem].date
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
