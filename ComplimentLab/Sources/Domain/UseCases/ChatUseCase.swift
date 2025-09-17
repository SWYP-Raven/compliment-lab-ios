//
//  ChatUseCasa.swift
//  ComplimentLab
//
//  Created by 이인호 on 9/6/25.
//

import Foundation
import RxSwift

protocol ChatUseCase {
    func postChat(createChatDTO: CreateChatDTO, friendId: Int, token: String) -> Observable<Chat>
    func getChats(friendId: Int, token: String) -> Observable<[Chat]>
    func postCard(createCardDTO: CreateCardDTO, token: String) -> Observable<Card>
    func getCard(date: String, token: String) -> Observable<[Card]>
    func deleteCard(id: Int, token: String) -> Observable<Void>
}
