//
//  ComplimentAPI.swift
//  ComplimentLab
//
//  Created by wayblemac02 on 9/4/25.
//

import Foundation
import RxSwift
import RxCocoa

final class ComplimentAPI: ComplimentUseCase {
    
    func getMonthlyCompliment(date: String, token: String) -> Observable<[DailyCompliment]> {
        let url = URL(string: "\(baseURL)/month/\(date)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatterManager.shared.apiFormatter)
        
        return URLSession.shared.rx.data(request: request)
            .map { data -> [DailyCompliment] in
                let response = try decoder.decode(ComplimentResponse.self, from: data)
                return response.compliments
            }
            .catchAndReturn([])
            .observe(on: MainScheduler.instance)
    }
    
    func getWeeklyCompliment(startDate: String, endDate: String, token: String) -> Observable<[DailyCompliment]> {
        let url = URL(string: "\(baseURL)/week?start=\(startDate)&end=\(endDate)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        return URLSession.shared.rx.data(request: request)
            .map { data -> [DailyCompliment] in
                let response = try decoder.decode(ComplimentResponse.self, from: data)
                return response.compliments
            }
            .catchAndReturn([])
            .observe(on: MainScheduler.instance)
    }
    
    func patchCompliment(editComplimentDTO: EditComplimentDTO, date: String, token: String) -> Observable<Void> {
        let url = URL(string: "\(baseURL)/logs/\(date)")!
        
        guard let jsonData = try? JSONEncoder().encode(editComplimentDTO) else {
            fatalError("Json Encode Error")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
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
    
    func archivedCompliment(date: String, token: String) -> Observable<[DailyCompliment]> {
        let url = URL(string: "\(baseURL)/archived/\(date)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatterManager.shared.apiFormatter)
        
        return URLSession.shared.rx.data(request: request)
            .map { data -> [DailyCompliment] in
                let response = try decoder.decode(ComplimentResponse.self, from: data)
                return response.compliments
            }
            .catchAndReturn([])
            .observe(on: MainScheduler.instance)
    }
}
