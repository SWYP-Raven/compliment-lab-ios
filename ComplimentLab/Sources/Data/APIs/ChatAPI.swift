//
//  ChatAPI.swift
//  ComplimentLab
//
//  Created by 이인호 on 9/6/25.
//

import Foundation
import RxSwift

final class ChatAPI: ChatUseCase {
    private let baseURL: String
    
    init() {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String else {
            fatalError("BaseURL not set in plist")
        }
        self.baseURL = baseURL
    }
    
    func postChat(createChatDTO: CreateChatDTO, friendId: Int, token: String) -> Observable<Chat> {
        let url = URL(string: "\(baseURL)/friend/chat/\(friendId)")!
        
        guard let jsonData = try? JSONEncoder().encode(createChatDTO) else {
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
            .map { response, data -> Chat in
                let response = try decoder.decode(PostChatResponse.self, from: data)
                return response.data
            }
            .catchAndReturn(Chat(id: 0, time: Date(), message: "", name: "", role: .ASSISTANT))
            .observe(on: MainScheduler.instance)
    }
    
    func getChats(friendId: Int, token: String) -> Observable<[Chat]> {
        let url = URL(string: "\(baseURL)/friend/chat/\(friendId)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        return URLSession.shared.rx.data(request: request)
            .map { data -> [Chat] in
                let response = try decoder.decode(GetChatResponse.self, from: data)
                
                return response.data.chats.sorted { $0.time < $1.time }
            }
            .catchAndReturn([])
            .observe(on: MainScheduler.instance)
    }
    
    func postCard(createCardDTO: CreateCardDTO, token: String) -> Observable<Card>  {
        let url = URL(string: "\(baseURL)/archive/chat-cards")!
        
        guard let jsonData = try? JSONEncoder().encode(createCardDTO) else {
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
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        return URLSession.shared.rx.response(request: request)
            .map { response, data -> Card in
                let response = try decoder.decode(Card.self, from: data)
                return response
            }
            .catchAndReturn(Card(id: 0, chatId: 0, type: .energetic, message: "", role: .ASSISTANT, createdAt: Date()))
            .observe(on: MainScheduler.instance)
    }
    
    func getCard(date: String, token: String) -> Observable<[Card]> {
        let url = URL(string: "\(baseURL)/archive/chat-cards/\(date)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        return URLSession.shared.rx.response(request: request)
            .map { response, data -> [Card] in
                let response = try decoder.decode(CardResponse.self, from: data)
                return response.chatCards
            }
            .catchAndReturn([])
            .observe(on: MainScheduler.instance)
    }
    
    func deleteCard(id: Int, token: String) -> Observable<Void> {
        let url = URL(string: "\(baseURL)/archive/chat-cards/\(id)")!
        
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
