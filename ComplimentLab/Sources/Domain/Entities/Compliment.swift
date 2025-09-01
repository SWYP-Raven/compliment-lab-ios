//
//  Compliment.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/27/25.
//

import Foundation

struct Compliment: Identifiable, Codable, Hashable {
    let id: String
    let text: String
    let date: Date
    let type: String
    let archived: Bool
    let isChecked: Bool
    
    static var mockCompliments: [Compliment] = [
        Compliment(
            id: UUID().uuidString,
            text: "오늘도 고생 많았어요!\n작은 노력들이 모여 큰 변화를 만들어요.",
            date: ISO8601DateFormatter().date(from: "2025-07-16T00:00:00Z")!,
            type: "",
            archived: false,
            isChecked: false
        ),
        Compliment(
            id: UUID().uuidString,
            text: "작은 노력들이 모여 큰 변화를 만들어요.",
            date: ISO8601DateFormatter().date(from: "2025-08-05T00:00:00Z")!,
            type: "",
            archived: false,
            isChecked: true
        ),
        Compliment(
            id: UUID().uuidString,
            text: "꾸준함이 가장 큰 힘이에요.",
            date: ISO8601DateFormatter().date(from: "2025-08-15T00:00:00Z")!,
            type: "",
            archived: true,
            isChecked: false
        ),
        Compliment(
            id: UUID().uuidString,
            text: "당신의 성장은 멋져요!",
            date: ISO8601DateFormatter().date(from: "2025-08-24T00:00:00Z")!,
            type: "",
            archived: false,
            isChecked: false
        ),
        Compliment(
            id: UUID().uuidString,
            text: "믿음직스럽고 든든해요.",
            date: ISO8601DateFormatter().date(from: "2025-08-26T00:00:00Z")!,
            type: "",
            archived: true,
            isChecked: true
        )
    ]
}
