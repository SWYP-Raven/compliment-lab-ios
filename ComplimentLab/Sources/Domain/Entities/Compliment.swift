//
//  Compliment.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/27/25.
//

import Foundation

struct ComplimentResponse: Codable {
    let compliments: [DailyCompliment]
}

struct Compliment: Identifiable, Codable, Hashable {
    let id: Int
    let content: String
    let type: FriendType
    
    enum CodingKeys: String, CodingKey {
        case id, content, type
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.type = try container.decode(FriendType.self, forKey: .type)
        
        let rawContent = try container.decode(String.self, forKey: .content)
        self.content = rawContent.replacingOccurrences(of: "\\n", with: "\n")
    }
    
    init(id: Int, content: String, type: FriendType) {
        self.id = id
        self.content = content
        self.type = type
    }
}

struct DailyCompliment: Codable, Hashable {
    let compliment: Compliment
    let date: Date
    var isArchived: Bool
    var isRead: Bool
    
    enum CodingKeys: String, CodingKey {
        case compliment, date
        case isArchived = "is_archived"
        case isRead = "is_read"
    }
}
