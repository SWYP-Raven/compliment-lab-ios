//
//  ChatingViewModel.swift
//  ComplimentLab
//
//  Created by CatSlave on 9/1/25.
//

import SwiftUI

struct ChatData: Codable, Identifiable {
    var id = UUID()
    let chats: [ChatMessage]
    let hasNext: Bool
}

struct ChatMessage: Codable, Identifiable {
    let id: Int
    let time: String
    let message: String
    let role: ChatRole
}

enum ChatRole: String, Codable {
    case SYSTEM = "SYSTEM"
    case USER = "USER"
}

@MainActor
final class ChatingViewModel: ObservableObject {
    @Published var chatingList: [ChatMessage] = mockChatMessages
}


// MARK: - Mock
let mockChatMessages: [ChatMessage] = [
    ChatMessage(
        id: 1,
        time: "2025-09-01T19:13:00.000Z",
        message: "오늘 하루 정말 고생 많았어! 힘든 일들이 많았을 텐데 그래도 끝까지 포기하지 않고 해낸 모습이 너무 멋있다. 이런 네 모습을 보면서 나도 더 열심히 살아야겠다는 생각이 들어. 앞으로도 이런 마음가짐으로 함께 걸어가자!",
        role: .SYSTEM
    ),
    ChatMessage(
        id: 2,
        time: "2025-09-01T14:55:00.000Z",
        message: "잠깐 쉬어가도 돼",
        role: .SYSTEM
    ),
    ChatMessage(
        id: 3,
        time: "2025-08-31T18:30:00.000Z",
        message: "네가 말한 그 아이디어 정말 좋은 것 같아! 처음엔 어떻게 할지 막막했는데 네 덕분에 방향이 보이기 시작했어. 가끔 이렇게 새로운 시각으로 문제를 바라보는 네 능력이 정말 부럽다.",
        role: .SYSTEM
    ),
    ChatMessage(
        id: 4,
        time: "2025-08-30T12:20:00.000Z",
        message: "고마워",
        role: .USER
    ),
    ChatMessage(
        id: 5,
        time: "2025-08-29T16:45:00.000Z",
        message: "와 진짜 대박이다! 네가 이런 걸 해낼 줄 몰랐는데 정말 놀라워. 평소에 조용조용하게 준비하더니 이런 멋진 결과를 보여주다니. 앞으로 또 어떤 놀라운 모습을 보여줄지 벌써부터 기대된다!",
        role: .SYSTEM
    ),
    ChatMessage(
        id: 6,
        time: "2025-08-28T09:30:00.000Z",
        message: "오늘은 어떤 하루였어?",
        role: .SYSTEM
    ),
    ChatMessage(
        id: 7,
        time: "2025-08-27T21:15:00.000Z",
        message: "힘들 때는 말해줘도 돼. 혼자 끙끙 앓지 말고 언제든 이야기하자. 네가 힘들어하는 모습을 보면 나도 마음이 아프거든. 우리가 함께 있으니까 뭐든 해결할 수 있을 거야.",
        role: .SYSTEM
    ),
    ChatMessage(
        id: 8,
        time: "2025-08-26T15:42:00.000Z",
        message: "넘 좋다!",
        role: .USER
    ),
    ChatMessage(
        id: 9,
        time: "2025-08-25T11:28:00.000Z",
        message: "네 웃는 모습 보니까 나도 덩달아 기분이 좋아져",
        role: .SYSTEM
    ),
    ChatMessage(
        id: 10,
        time: "2025-08-24T18:55:00.000Z",
        message: "요즘 부쩍 성장한 것 같아. 예전보다 훨씬 자신감 있게 말하고 행동하는 모습이 보여서 정말 뿌듯해. 이런 변화가 하루아침에 생긴 건 아닐 텐데, 그동안 얼마나 노력했을지 짐작이 가. 앞으로도 지금처럼 꾸준히 해나가면 분명 더 멋진 사람이 될 거야!",
        role: .SYSTEM
    )
]
