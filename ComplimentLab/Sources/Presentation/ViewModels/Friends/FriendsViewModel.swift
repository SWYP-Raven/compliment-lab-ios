//
//  FirendsViewModel.swift
//  ComplimentLab
//
//  Created by CatSlave on 9/1/25.
//

import Foundation
import SwiftUI

enum FriendType: String, CaseIterable, Codable {
    case kind = "5"
    case energetic = "4"
    case studious = "3"
    case special = "2"
    case quiet = "1"

    var title: String {
        switch self {
        case .kind:
            return "🌱 차근차근 칭구"
        case .energetic:
            return "📷 활발한 칭구"
        case .studious:
            return "📚 똑똑한 칭구"
        case .special:
            return "☀️ 특별한 칭구"
        case .quiet:
            return "🏁 든든한 칭구"
        }
    }
    
    var description: String {
        switch self {
        case .kind:
            return "\"오늘도 한 발자국 나아갔네.\""
        case .energetic:
            return "\"방금 그거 너무 멋있었어!\""
        case .studious:
            return "\"그럴 땐 이런 방법도 있어~\""
        case .special:
            return "\"너는 참 너답게 빛나.\""
        case .quiet:
            return "\"드디어 해냈구나\""
        }
    }
    
    var color1: Color {
        switch self {
        case .kind:
            return Color.pink1
        case .energetic:
            return Color.yellow1
        case .studious:
            return Color.violet1
        case .special:
            return Color.green1
        case .quiet:
            return Color.blue1
        }
    }
    
    var color2: Color {
        switch self {
        case .kind:
            return Color.pink2
        case .energetic:
            return Color.yellow2
        case .studious:
            return Color.violet2
        case .special:
            return Color.green2
        case .quiet:
            return Color.blue2
        }
    }
    
    var stickerSImage: Image {
        switch self {
        case .kind:
            return Image("Character Pink Stiker S")
        case .energetic:
            return Image("Character Yellow Stiker S")
        case .studious:
            return Image("Character Violet Stiker S")
        case .special:
            return Image("Character Green Stiker S")
        case .quiet:
            return Image("Character Blue Stiker S")
        }
    }
    
    var stickerLImage: Image {
        switch self {
        case .kind:
            return Image("Character Pink Stiker L")
        case .energetic:
            return Image("Character Yellow Stiker L")
        case .studious:
            return Image("Character Violet Stiker L")
        case .special:
            return Image("Character Green Stiker L")
        case .quiet:
            return Image("Character Blue Stiker L")
        }
    }
}

struct FriendChating: Identifiable {
    let id = UUID()
    let type: FriendType
    let message: String
    let name: String
    let dateString: String
}

@MainActor
final class FriendsViewModel: ObservableObject {
    @Published var chatingList: [FriendChating] = [.init(type: .kind, message: "테스트메세지", name: "테스트", dateString: "오후 7:13"),
                                                   .init(type: .energetic, message: "테스트메세지", name: "테스트", dateString: "오후 7:13"),
                                                   .init(type: .quiet, message: "테스트메세지", name: "테스트", dateString: "오후 7:13"),
                                                   .init(type: .special, message: "테스트메세지", name: "테스트", dateString: "오후 7:13")]
}

