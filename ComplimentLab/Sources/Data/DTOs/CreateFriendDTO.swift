//
//  CreateFriendDTO.swift
//  ComplimentLab
//
//  Created by 이인호 on 9/6/25.
//

import Foundation

struct CreateFriendDTO: Codable {
    let name: String
    let friendType: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case friendType = "friend_type"
    }
}
