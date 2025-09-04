//
//  LoginView.swift
//  ComplimentLab
//
//  Created by CatSlave on 8/8/25.
//


import UIKit

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var isSignup: Bool?
    
    func loginWithApple(identityToken: String) {
        print(#function, #line, "Path : # ")
        guard let url = URL(string: "https://dev.compliment-lab.store/auth/apple") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loginRequest = LoginRequest(identityToken: identityToken)
        
        do {
            request.httpBody = try JSONEncoder().encode(loginRequest)
        } catch {
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard error == nil,
                      let data,
                      let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data),
                      loginResponse.success else { return }
                
                self?.isSignup = loginResponse.data.isSignup
                
                self?.saveTokens(
                    accessToken: loginResponse.data.accessToken,
                    refreshToken: loginResponse.data.refreshToken
                )
            }
        }.resume()
    }
    
    // MARK: - Token Management
    private func saveTokens(accessToken: String, refreshToken: String) {
        let token = Token(accessToken: accessToken, refreshToken: refreshToken)
        let tokenData = try? JSONEncoder().encode(token)
        KeychainStorage.shared.saveToken(tokenData)
    }
}
