//
//  GameMatchingViewModel.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2022/01/09.
//

import Foundation

class GameMatchingViewModel {

    //중현: 생성하는 시점에 viewModel을 fetch
    init() {
        self.fetchMatchingList()
    }

    private func fetchMatchingList() {
        self.matchingListViewModel = [GameMatchListViewModel.mockData,
                                      GameMatchListViewModel.mockData1,
                                      GameMatchListViewModel.mockData2]
    }

    // MARK: - Properties
    internal private(set) var selectedDate: [Date] = []

    internal var count: Int {
        self.matchingListViewModel.count
    }

    internal func fetchViewModel(indexPath: IndexPath) -> GameMatchListViewModel {
        self.matchingListViewModel[indexPath.row]
    }

    private var matchingListViewModel: [GameMatchListViewModel] = []

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
