//
//  CellData.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/07/17.
//

import Foundation

struct CellData {
    var indexPath: IndexPath?
    var weeks: [String] = ["토","일","월","화","수","목","금"]
    var dayOfTheWeek: Int?
    var date: String?
    var stackviewTappedBool: Bool?
}
