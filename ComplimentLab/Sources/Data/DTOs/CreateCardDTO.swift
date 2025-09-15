//
//  CreateCardDTO.swift
//  ComplimentLab
//
//  Created by 이인호 on 9/7/25.
//

import Foundation

struct CreateCardDTO: Codable {
    let chatId: Int
    let message: String
    let role: ChatRole
}
