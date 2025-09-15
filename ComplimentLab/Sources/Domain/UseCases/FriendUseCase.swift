//
//  FriendUseCase.swift
//  ComplimentLab
//
//  Created by 이인호 on 9/6/25.
//

import Foundation
import RxSwift

protocol FriendUseCase {
    func createFriend(createFriendDTO: CreateFriendDTO, token: String) -> Observable<Friend>
    func getFriends(token: String) -> Observable<[Friend]>
    func deleteFriend(friendId: Int, token: String) -> Observable<Void>
}
