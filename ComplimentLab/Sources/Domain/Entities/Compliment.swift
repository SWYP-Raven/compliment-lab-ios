//
//  Compliment.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/27/25.
//

import Foundation

struct Compliment: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let type: String
}

struct DailyCompliment: Codable, Identifiable, Hashable {
    let id: String
    let compliment: Compliment
    let date: Date
    var isArchived: Bool
    var isRead: Bool
    
    static var mockCompliments: [DailyCompliment] = [
        DailyCompliment(
            id: UUID().uuidString,
            compliment: Compliment(
                id: UUID().uuidString,
                title: "오늘도 고생 많았어요!\n작은 노력들이 모여 큰 변화를 만들어요.",
                type: "과정"
            ),
            date: ISO8601DateFormatter().date(from: "2025-07-16T00:00:00Z")!,
            isArchived: false,
            isRead: false
        ),
        DailyCompliment(
            id: UUID().uuidString,
            compliment: Compliment(
                id: UUID().uuidString,
                title: "작은 노력들이 모여 큰 변화를 만들어요.",
                type: "행동"
            ),
            date: ISO8601DateFormatter().date(from: "2025-08-05T00:00:00Z")!,
            isArchived: false,
            isRead: true
        ),
        DailyCompliment(
            id: UUID().uuidString,
            compliment: Compliment(
                id: UUID().uuidString,
                title: "꾸준함이 가장 큰 힘이에요.",
                type: "과정"
            ),
            date: ISO8601DateFormatter().date(from: "2025-08-15T00:00:00Z")!,
            isArchived: true,
            isRead: false
        ),
        DailyCompliment(
            id: UUID().uuidString,
            compliment: Compliment(
                id: UUID().uuidString,
                title: "당신의 성장은 멋져요!",
                type: "결과"
            ),
            date: ISO8601DateFormatter().date(from: "2025-08-24T00:00:00Z")!,
            isArchived: false,
            isRead: false
        ),
        DailyCompliment(
            id: UUID().uuidString,
            compliment: Compliment(
                id: UUID().uuidString,
                title: "믿음직스럽고 든든해요.",
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
