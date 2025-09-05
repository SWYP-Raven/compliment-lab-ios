//
//  EditComplimentDTO.swift
//  ComplimentLab
//
//  Created by wayblemac02 on 9/4/25.
//

import Foundation

struct EditComplimentDTO: Codable {
    let isArchived: Bool
    let isRead: Bool
    
    enum CodingKeys: String, CodingKey {
        case isArchived = "is_archived"
        case isRead = "is_read"
    }
}
