//
//  CellData.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/07/17.
//

import Foundation
import UIKit

struct HorizontalCalendarModel {
    internal var weeks: [String] = ["토","일","월","화","수","목","금"]

    internal var date: Date

    internal var weeksDay: Int {
        let calendar = Calendar.current
        let dayOfTheWeekint = calendar.component(.weekday, from: self.date)
        return dayOfTheWeekint
    }

    internal var dayText: String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        let chagedDateDay = calendar.dateComponents([.day], from: self.date).day
        if chagedDateDay == 1 {
            dateFormatter.dateFormat = "M/d"
        } else {
            dateFormatter.dateFormat = "d"
        }
        let dateString = dateFormatter.string(from: self.date)
        return dateString
    }

    internal var weeksDayText: String {
        return self.weeks[self.weeksDay % 7]
    }

    internal var dayTextColor: UIColor {
        if self.weeksDay % 7 == NumberOfDays.sunday.rawValue {
            // 일요일
            return .red
        } else if self.weeksDay % 7 == NumberOfDays.saturday.rawValue {
            // 토요일
            return .blue
        } else {
            // 평일
            return .black
        }
    }

    internal var dateTextColor: UIColor {
        if self.weeksDay % 7 == NumberOfDays.sunday.rawValue {
            // 일요일
            return .red
        } else if self.weeksDay % 7 == NumberOfDays.saturday.rawValue {
            // 토요일
            return .blue
        } else {
            // 평일
            return .black
        }
    }
}
