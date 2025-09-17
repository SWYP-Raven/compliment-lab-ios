//
//  Card.swift
//  ComplimentLab
//
//  Created by 이인호 on 9/7/25.
//

import Foundation

struct CardResponse: Codable {
    let chatCards: [Card]
    
    enum CodingKeys: String, CodingKey {
        case chatCards = "chat_cards"
    }
}

struct Card: Identifiable, Codable, Hashable {
    let id: Int
    let chatId: Int
    let type: FriendType
    let message: String
    let role: ChatRole
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, message, role
        case chatId = "chat_id"
        case type = "type_id"
        case createdAt = "created_at"
    }
}
