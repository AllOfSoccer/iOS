//
//  CellData.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/07/17.
//

import Foundation
import UIKit

struct HorizontalCalendarModel {
    var weeks: [String] = ["토","일","월","화","수","목","금"]
    var dayOfTheWeek: Int?
    var date: String?

    var dayText: String {
        guard let dayOfTheWeek = self.dayOfTheWeek else {
            return ""
        }

        return self.weeks[dayOfTheWeek % 7]
    }

    var dateText: String {
        guard let dayOfTheWeek = self.dayOfTheWeek else {
            return ""
        }

        return self.date ?? ""
    }

    var dayTextColor: UIColor {
        guard let dayOfTheWeek = self.dayOfTheWeek else {
            return .white
        }

        if dayOfTheWeek % 7 == NumberOfDays.sunday.rawValue {
            // 일요일
            return .red
        } else if dayOfTheWeek % 7 == NumberOfDays.saturday.rawValue {
            // 토요일
            return .blue
        } else {
            // 평일
            return .black
        }
    }

    var dateTextColor: UIColor {
        guard let dayOfTheWeek = self.dayOfTheWeek else {
            return .white
        }

        if dayOfTheWeek % 7 == NumberOfDays.sunday.rawValue {
            // 일요일
            return .red
        } else if dayOfTheWeek % 7 == NumberOfDays.saturday.rawValue {
            // 토요일
            return .blue
        } else {
            // 평일
            return .black
        }
    }
}
