//
//  Notice.swift
//  ComplimentLab
//
//  Created by 이인호 on 9/2/25.
//

import Foundation

struct Notice: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let content: String
    let createdAt: Date
}
