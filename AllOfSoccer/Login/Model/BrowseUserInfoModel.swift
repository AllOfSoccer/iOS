//
//  aslsacaklans.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/11/27.
//

import Foundation

struct BrowseUserInfoModel: Codable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let displayName: String
    let displayPhone: String
    let ageRange: Int
    let skillLevel: Int
    let teamIds: String
    let profileImgUrl: String
    let introduction: String
}
