//
//  ProfileSetupViewModel.swift
//  ComplimentLab
//
//  Created by CatSlave on 9/5/25.
//

import UIKit

@MainActor
final class ProfileSetupViewModel: ObservableObject {
    @Published var completed: Void?
    
    func requestSetProfile(name: String) {
        print(#function, #line, "Path : # ")
        guard let url = URL(string: "https://dev.compliment-lab.store/user"),
        let accessToken = KeychainStorage.shared.getToken()?.accessToken else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let profileRequest = ProfileUpdateRequest(nickname: name)
        
        do {
            request.httpBody = try JSONEncoder().encode(profileRequest)
        } catch {
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    let dataString = String(data: data, encoding: .utf8) ?? "인코딩 실패"
                }
                
                guard error == nil,
                      let data,
                      let response = try? JSONDecoder().decode(ProfileUpdateResponse.self, from: data),
                      response.success else {
                    return
                }
                
                self?.completed = ()
                self?.saveUsername(response.data.nickname)
            }
        }.resume()
    }
    
    // MARK: - Token Management
    private func saveUsername(_ name: String) {
        UserDefaults.standard.set(name, forKey: "username")
    }
}
