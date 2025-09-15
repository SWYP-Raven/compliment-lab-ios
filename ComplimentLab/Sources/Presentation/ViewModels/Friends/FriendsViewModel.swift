//
//  FirendsViewModel.swift
//  ComplimentLab
//
//  Created by CatSlave on 9/1/25.
//

import Foundation
import SwiftUI
import RxSwift

@MainActor
final class FriendsViewModel: ObservableObject {
    @Published var currentPage: FriendFlowPage = .create
    @Published var friends: [Friend] = []
    @Published var friend: Friend = Friend(id: 0, name: "", type: .energetic, lastMessage: LastMessage(message: "", time: Date()), isFirst: false)
    @Published var isLoading = true
    
    @Published var showFriendAlert: Bool = false
    @Published var friendAlertType: FriendAlertType = .deleteFriend
    
    let useCase: FriendUseCase
    let disposeBag = DisposeBag()
    
    init(useCase: FriendUseCase) {
        self.useCase = useCase
    }
    
    func createFriend(name: String, friendType: String) {
        let createFriendDTO = CreateFriendDTO(name: name, friendType: friendType)
        guard let accessToken = KeychainStorage.shared.getToken()?.accessToken else {
            return
        }
        
        useCase.createFriend(createFriendDTO: createFriendDTO, token: accessToken)
            .subscribe(onNext: { [weak self] item in
                self?.friend = item
            })
            .disposed(by: disposeBag)
    }
    
    func getFriends() {
        guard let accessToken = KeychainStorage.shared.getToken()?.accessToken else {
            return
        }
        
        useCase.getFriends(token: accessToken)
            .subscribe(onNext: { [weak self] items in
                self?.friends = items
                self?.isLoading = false
            })
            .disposed(by: disposeBag)
    }
    
    func deleteFriend(friendId: Int) {
        guard let accessToken = KeychainStorage.shared.getToken()?.accessToken else {
            return
        }
        
        useCase.deleteFriend(friendId: friendId, token: accessToken)
            .subscribe(
                onNext: {
                    if let index = self.friends.firstIndex(where: { $0.id == friendId }) {
                        self.friends.remove(at: index)
                    }
                    print("칭구 삭제 성공")
                },
                onError: { error in
                    print("칭구 삭제 실패: \(error)")
                }
            )
            .disposed(by: disposeBag)
    }
}

