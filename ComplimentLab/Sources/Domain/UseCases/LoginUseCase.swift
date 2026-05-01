//
//  LoginUseCase.swift
//  ComplimentLab
//
//  Created by 이인호 on 9/5/25.
//

import Foundation
import RxSwift

protocol LoginUseCase {
    func getUser(token: String) -> Observable<User>
    func editUser(editUserDTO: EditUserDTO, token: String) -> Observable<Void>
    func deleteUser(token: String) -> Observable<Void>
}
