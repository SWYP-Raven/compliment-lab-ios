//
//  LoginUseCase.swift
//  ComplimentLab
//
//  Created by 이인호 on 9/5/25.
//

import Foundation
import RxSwift

protocol LoginUseCase {
    func editUser(editUserDTO: EditUserDTO, token: String) -> Observable<Void>
}
