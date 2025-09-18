//
//  User.swift
//  ComplimentLab
//
//  Created by wayblemac02 on 9/18/25.
//

import Foundation

struct UserResponse: Codable {
    let success: Bool
    let code: String
    let message: String
    let data: User
}

struct User: Codable, Identifiable, Hashable {
    let id: Int
    var nickname: String
    let email: String
    let friendAlarm: Bool
    let archiveAlarm: Bool
    let marketingAlarm: Bool
    let eventAlarm: Bool
}
