//
//  dklands.swift
//  AllOfSoccer
//
//  Created by 최원석 on 2021/11/27.
//

import Foundation

struct SaveUserInfoModel: Codable {
    let ageRange: Int
    let displayName: String
    let displayPhone: String
    let email: String
    let id: Int
    let introduction: String
    let name: String
    let phone: String
    let profileImgUrl: String
    let skillLevel: Int
    let teamIds: String
}
