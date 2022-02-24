//
//  Date+Extension.swift
//  AllOfSoccer
//
//  Created by 조중현 on 2022/02/24.
//

import UIKit

extension Date {
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale.current

        return formatter.string(from: self)
    }

    var toDay: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale.current

        return formatter.string(from: self)
    }
}
