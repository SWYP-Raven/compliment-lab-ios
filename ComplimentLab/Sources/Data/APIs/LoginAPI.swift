//
//  LoginAPI.swift
//  ComplimentLab
//
//  Created by 이인호 on 9/5/25.
//

import Foundation
import RxSwift

final class LoginAPI: LoginUseCase {
    func editUser(editUserDTO: EditUserDTO, token: String) -> Observable<Void> {
        let url = URL(string: "https://dev.compliment-lab.store/user")!
        
        guard let jsonData = try? JSONEncoder().encode(editUserDTO) else {
            fatalError("Json Encode Error")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        return URLSession.shared.rx.response(request: request)
            .flatMap { response, _ -> Observable<Void> in
                if 200..<300 ~= response.statusCode {
                    return .just(())
                } else {
                    return .error(NSError(domain: "HTTPError", code: response.statusCode))
                }
            }
    }
}
