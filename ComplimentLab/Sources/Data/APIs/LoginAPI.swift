//
//  LoginAPI.swift
//  ComplimentLab
//
//  Created by 이인호 on 9/5/25.
//

import Foundation
import RxSwift

final class LoginAPI: LoginUseCase {
    private let baseURL: String
    
    init() {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String else {
            fatalError("BaseURL not set in plist")
        }
        self.baseURL = baseURL
    }
    
    func getUser(token: String) -> Observable<User> {
        let url = URL(string: "\(baseURL)/user")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.rx.data(request: request)
            .map { data -> User in
                let response = try JSONDecoder().decode(UserResponse.self, from: data)
                return response.data
            }
            .catchAndReturn(User(id: 0, nickname: "", email: "", friendAlarm: false, archiveAlarm: false, marketingAlarm: false, eventAlarm: false))
            .observe(on: MainScheduler.instance)
    }
    
    func editUser(editUserDTO: EditUserDTO, token: String) -> Observable<Void> {
        let url = URL(string: "\(baseURL)/user")!
        
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
            .observe(on: MainScheduler.instance)
    }
    
    func deleteUser(token: String) -> Observable<Void> {
        let url = URL(string: "\(baseURL)/user")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.rx.response(request: request)
            .flatMap { response, _ -> Observable<Void> in
                if 200..<300 ~= response.statusCode {
                    return .just(())
                } else {
                    return .error(NSError(domain: "HTTPError", code: response.statusCode))
                }
            }
            .observe(on: MainScheduler.instance)
    }
}
