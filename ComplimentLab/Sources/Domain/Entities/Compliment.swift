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
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case id, content, type
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.type = try container.decode(String.self, forKey: .type)
        
        let rawContent = try container.decode(String.self, forKey: .content)
        self.content = rawContent.replacingOccurrences(of: "\\n", with: "\n")
    }
    
    init(id: Int, content: String, type: String) {
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
    
    static var mockCompliments: [DailyCompliment] = [
        DailyCompliment(
            compliment: Compliment(
                id: 1,
                content: "오늘도 고생 많았어요!\n작은 노력들이 모여 큰 변화를 만들어요.",
                type: "과정"
            ),
            date: ISO8601DateFormatter().date(from: "2025-07-16T00:00:00Z")!,
            isArchived: false,
            isRead: false
        ),
        DailyCompliment(
            compliment: Compliment(
                id: 2,
                content: "작은 노력들이 모여 큰 변화를 만들어요.",
                type: "행동"
            ),
            date: ISO8601DateFormatter().date(from: "2025-08-05T00:00:00Z")!,
            isArchived: false,
            isRead: true
        ),
        DailyCompliment(
            compliment: Compliment(
                id: 3,
                content: "꾸준함이 가장 큰 힘이에요.",
                type: "과정"
            ),
            date: ISO8601DateFormatter().date(from: "2025-08-15T00:00:00Z")!,
            isArchived: true,
            isRead: false
        ),
        DailyCompliment(
            compliment: Compliment(
                id: 4,
                content: "당신의 성장은 멋져요!",
                type: "결과"
            ),
            date: ISO8601DateFormatter().date(from: "2025-08-24T00:00:00Z")!,
            isArchived: false,
            isRead: false
        ),
        DailyCompliment(
            compliment: Compliment(
                id: 5,
                content: "믿음직스럽고 든든해요.",
                type: "행동"
            ),
            date: ISO8601DateFormatter().date(from: "2025-09-03T00:00:00Z")!,
            isArchived: true,
            isRead: true
        )
    ]
    
    static let mockComplimentsMap: [Date: DailyCompliment] =
        Dictionary(uniqueKeysWithValues: mockCompliments.map { (Calendar.current.startOfDay(for: $0.date), $0) })
}
