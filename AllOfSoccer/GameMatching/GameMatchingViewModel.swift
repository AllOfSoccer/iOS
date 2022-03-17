//
//  GameMatchingViewModel.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2022/01/09.
//

import Foundation

class GameMatchingViewModel {

    // MARK: - Properties
    internal private(set) var selectedDate: [Date] = []

    internal var formalStrSelectedDate: [String] {
        let strSelectedDate = self.selectedDate.map { self.changeDateToString($0) }
        return strSelectedDate
    }

    // MARK: - Function
    internal func append(_ dates: [Date], _ date: Date?) {

        if let date = date {
            self.selectedDate.append(date)
        } else {
            self.selectedDate = dates
        }
    }

    internal func delete(_ date: Date) {
        let deselectedDateStr = self.changeDateToString(date)

        let selectedDateArry = self.selectedDate.map { $0.changedSringFromDate }

        guard let indexOfDate = selectedDateArry.firstIndex(of: deselectedDateStr) else { return }
        self.selectedDate.remove(at: indexOfDate)
    }
}

extension GameMatchingViewModel {
    private func changeDateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")

        let changedSelectedDate = dateFormatter.string(from: date)

        return changedSelectedDate
    }
}