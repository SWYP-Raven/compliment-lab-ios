//
//  Friend.swift
//  ComplimentLab
//
//  Created by 이인호 on 9/6/25.
//

import Foundation

struct GetFriendResponse: Codable {
    let success: Bool
    let code: String
    let message: String
    let data: [Friend]
}

struct PostFriendResponse: Codable {
    let success: Bool
    let code: String
    let message: String
    let data: Friend
}

struct Friend: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let type: FriendType
    let lastMessage: LastMessage
    let isFirst: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case type = "type_id"
        case lastMessage = "last_message"
        case isFirst = "is_first"
    }
}

struct LastMessage: Codable, Hashable {
    let message: String
    let time: Date
}
