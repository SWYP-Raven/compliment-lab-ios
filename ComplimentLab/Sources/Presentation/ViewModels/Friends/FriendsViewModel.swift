//
//  FirendsViewModel.swift
//  ComplimentLab
//
//  Created by CatSlave on 9/1/25.
//

import Foundation

enum FriendType: String, CaseIterable {
    case kind
    case energetic
    case studious
    case special
    case quiet

    var title: String {
        switch self {
        case .kind:
            return "🌱 차근차근 친구"
        case .energetic:
            return "📷 활발한 친구"
        case .studious:
            return "📚 똑똑한 친구"
        case .special:
            return "☀️ 특별한 친구"
        case .quiet:
            return "🏁 든든한 친구"
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

