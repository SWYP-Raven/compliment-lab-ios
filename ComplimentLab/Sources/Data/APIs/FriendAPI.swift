//
//  FriendAPI.swift
//  ComplimentLab
//
//  Created by 이인호 on 9/6/25.
//

import Foundation
import RxSwift

final class FriendAPI: FriendUseCase {
    private let baseURL: String
    
    init() {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String else {
            fatalError("BaseURL not set in plist")
        }
        self.baseURL = baseURL
    }
    
    func createFriend(createFriendDTO: CreateFriendDTO, token: String) -> Observable<Friend> {
        let url = URL(string: "\(baseURL)/friend")!
        
        guard let jsonData = try? JSONEncoder().encode(createFriendDTO) else {
            fatalError("Json Encode Error")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        return URLSession.shared.rx.response(request: request)
            .map { response, data -> Friend in
                let response = try decoder.decode(PostFriendResponse.self, from: data)
                return response.data
            }
            .catchAndReturn(Friend(id: 0, name: "", typeId: .energetic, lastMessage: LastMessage(message: "", time: Date()), isFirst: false))
            .observe(on: MainScheduler.instance)
    }
    
    func getFriends(token: String) -> Observable<[Friend]> {
        let url = URL(string: "\(baseURL)/friend")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        return URLSession.shared.rx.data(request: request)
            .map { data -> [Friend] in
                let response = try decoder.decode(GetFriendResponse.self, from: data)
                
                return response.data
            }
            .catchAndReturn([])
            .observe(on: MainScheduler.instance)
    }
    
    func deleteFriend(friendId: Int, token: String) -> Observable<Void> {
        let url = URL(string: "\(baseURL)/friend/\(friendId)")!
        
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
