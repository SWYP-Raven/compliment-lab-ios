//
//  ChatingViewModel.swift
//  ComplimentLab
//
//  Created by CatSlave on 9/1/25.
//

import SwiftUI
import RxSwift

@MainActor
final class ChatingViewModel: ObservableObject {
    @Published var chats: [Chat] = []
    @Published var didLoad = false
    @Published var makeCard = false
    @Published var cards: [Card] = []
    @Published var card: Card = Card(id: 0, chatId: 0, type: .energetic, message: "", role: .ASSISTANT, createdAt: Date())
    
    @Published var showCardAlert: Bool = false
    
    var createCardDTO: CreateCardDTO = CreateCardDTO(chatId: 0, message: "", role: .ASSISTANT)
    
    let useCase: ChatUseCase
    let disposeBag = DisposeBag()
    
    init(useCase: ChatUseCase) {
        self.useCase = useCase
    }
    
    func postChat(message: String, friendId: Int) {
        let createChatDTO = CreateChatDTO(message: message)
        
        guard let accessToken = KeychainStorage.shared.getToken()?.accessToken else {
            return
        }
        
        let chat = Chat(id: chats.last!.id + 1, time: Date(), message: message, name: "", role: .USER)
        chats.append(chat)
        
        useCase.postChat(createChatDTO: createChatDTO, friendId: friendId, token: accessToken)
            .subscribe(onNext: { [weak self] item in
                self?.chats.append(item)
            })
            .disposed(by: disposeBag)
    }
    
    func getChats(friendId: Int) {
        guard let accessToken = KeychainStorage.shared.getToken()?.accessToken else {
            return
        }
        
        useCase.getChats(friendId: friendId, token: accessToken)
            .subscribe(onNext: { [weak self] items in
                self?.chats = items
                self?.didLoad = true
            })
            .disposed(by: disposeBag)
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
