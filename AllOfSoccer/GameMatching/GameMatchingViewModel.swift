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
}
