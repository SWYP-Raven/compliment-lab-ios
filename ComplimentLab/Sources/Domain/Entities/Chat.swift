//
//  Chats.swift
//  ComplimentLab
//
//  Created by 이인호 on 9/6/25.
//

import Foundation

struct GetChatResponse: Codable {
    let success: Bool
    let code: String
    let message: String
    let data: ChatData
}

struct PostChatResponse: Codable {
    let success: Bool
    let code: String
    let message: String
    let data: Chat
}

struct ChatData: Codable {
    let chats: [Chat]
    let hasNext: Bool
}

struct Chat: Identifiable, Codable, Hashable {
    let id: Int
    let time: Date
    let message: String
    let name: String
    let role: ChatRole
}

enum ChatRole: String, Codable {
    case ASSISTANT = "ASSISTANT"
    case USER = "USER"
}
