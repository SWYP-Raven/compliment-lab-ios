//
//  EditUserDTO.swift
//  ComplimentLab
//
//  Created by 이인호 on 9/5/25.
//

import Foundation

struct EditUserDTO: Codable {
    let nickname: String
    let friendAlarm: Bool
    let archiveAlarm: Bool
    let marketingAlarm: Bool
    let eventAlarm: Bool
}
