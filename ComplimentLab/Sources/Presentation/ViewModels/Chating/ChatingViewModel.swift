//
//  ChatingViewModel.swift
//  ComplimentLab
//
//  Created by CatSlave on 9/1/25.
//

import Foundation
import RxSwift

@MainActor
final class ChatingViewModel: ObservableObject {
    @Published var chats: [Chat] = []
    @Published var didLoad = false
    
    @Published var card: Card = Card(id: 0, chatId: 0, type: .energetic, message: "", role: .ASSISTANT, createdAt: Date())
    @Published var cards: [Card] = []
    @Published var makeCard = false
    @Published var showCardAlert = false
    
    var createCardDTO: CreateCardDTO = CreateCardDTO(chatId: 0, message: "", role: .ASSISTANT)
    
    let useCase: ChatUseCase
    let disposeBag = DisposeBag()
    
    init(useCase: ChatUseCase) {
        self.useCase = useCase
    }
    
    func postChat(message: String, friendId: Int) {
        let nextId = (chats.map { $0.id }.max() ?? 0) + 1
        chats.append(Chat(id: nextId, time: Date(), message: message, name: "", role: .USER))
        appendErrorResponse()
    }

    func getChats(friendId: Int) {
        guard let accessToken = KeychainStorage.shared.getToken()?.accessToken else {
            didLoad = true
            return
        }

        useCase.getChats(friendId: friendId, token: accessToken)
            .subscribe(
                onNext: { [weak self] items in
                    self?.chats = items
                    self?.didLoad = true
                },
                onError: { [weak self] _ in
                    self?.didLoad = true
                }
            )
            .disposed(by: disposeBag)
    }

    private func appendErrorResponse() {
        let errorId = (chats.map { $0.id }.max() ?? 0) + 1
        let errorChat = Chat(
            id: errorId,
            time: Date(),
            message: "서비스 준비 중이에요. 곧 더 나은 모습으로 찾아올게요!",
            name: "",
            role: .ASSISTANT
        )
        chats.append(errorChat)
    }
    
    func postCard(createCardDTO: CreateCardDTO) {
        guard let accessToken = KeychainStorage.shared.getToken()?.accessToken else {
            return
        }
        
        useCase.postCard(createCardDTO: createCardDTO, token: accessToken)
            .subscribe(onNext: { [weak self] item in
                self?.card = item
            })
            .disposed(by: disposeBag)
    }
    
    func deleteCard(id: Int) {
        guard let accessToken = KeychainStorage.shared.getToken()?.accessToken else {
            return
        }
        
        useCase.deleteCard(id: id, token: accessToken)
            .subscribe(
                onNext: {
                    print("카드 삭제 성공")
                },
                onError: { error in
                    print("카드 삭제 실패: \(error)")
                }
            )
            .disposed(by: disposeBag)
    }
}
