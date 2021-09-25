//
//  APIError.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/09/02.
//

import Foundation

enum APIError: LocalizedError {
    case urlNotSupport
    case noData

    var errorDesCription: String? {
        switch self {
        case .urlNotSupport: return "URL NOT Supported"
        case .noData: return "Has No Data"
        }
    }
}
