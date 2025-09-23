//
//  LoginView.swift
//  ComplimentLab
//
//  Created by CatSlave on 8/8/25.
//


import UIKit
import RxSwift

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var completed: Void?
    @Published var isSignup: Bool?
    @Published var naviToProfileEdit = false
    @Published var hasToken: Bool = KeychainStorage.shared.hasToken()
    @Published var username: String = UserDefaults.standard.string(forKey: "username") ?? "" {
        didSet {
            UserDefaults.standard.set(username, forKey: "username")
        }
    }
    
    var pendingAccessToken: String?
    var pendingRefreshToken: String?

    let useCase: LoginUseCase
    let disposeBag = DisposeBag()
    
    init(useCase: LoginUseCase) {
        self.useCase = useCase
        self.fetchUserIfNeeded()
    }
    
    func loginWithApple(identityToken: String) {
        print(#function, #line, "Path : # ")
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String, let url = URL(string: "\(baseURL)/auth/apple") else {
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
                
                if loginResponse.data.isSignup {
                    self?.saveTokens(
                        accessToken: loginResponse.data.accessToken,
                        refreshToken: loginResponse.data.refreshToken
                    )
                    
                    if loginResponse.data.isSignup {
                        self?.useCase.getUser(token: loginResponse.data.accessToken)
                            .subscribe(onNext: { user in
                                self?.username = user.nickname
                            })
                            .disposed(by: self!.disposeBag)
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.pendingAccessToken = loginResponse.data.accessToken
                        self?.pendingRefreshToken = loginResponse.data.refreshToken
                    }
                }
            }
        }.resume()
    }
    
    // MARK: - Token Management
    private func saveTokens(accessToken: String, refreshToken: String) {
        let token = Token(accessToken: accessToken, refreshToken: refreshToken)
        let tokenData = try? JSONEncoder().encode(token)
        KeychainStorage.shared.saveToken(tokenData)
        hasToken = true
    }
    
    func logout() {
        KeychainStorage.shared.deleteToken()
        hasToken = false
    }
    
    func editUser(nickname: String) {
        let editUserDTO = EditUserDTO(nickname: nickname, friendAlarm: true, archiveAlarm: true, marketingAlarm: true, eventAlarm: true)
        
        guard let accessToken = KeychainStorage.shared.getToken()?.accessToken else {
            return
        }
        
        useCase.editUser(editUserDTO: editUserDTO, token: accessToken)
            .subscribe(
                onNext: {
                    self.username = nickname
                    print("닉네임 변경 성공")
                },
                onError: { error in
                    print("닉네임 변경 실패: \(error)")
                }
            )
            .disposed(by: disposeBag)
    }
    
    func deleteUser() {
        guard let accessToken = KeychainStorage.shared.getToken()?.accessToken else {
            return
        }
        
        useCase.deleteUser(token: accessToken)
            .subscribe(
                onNext: {
                    if let bundleID = Bundle.main.bundleIdentifier {
                        UserDefaults.standard.removePersistentDomain(forName: bundleID)
                        UserDefaults.standard.synchronize()
                    }
                    KeychainStorage.shared.deleteToken()
                    self.hasToken = false
                    print("유저 탈퇴 성공")
                },
                onError: { error in
                    print("유저 탈퇴 실패: \(error)")
                }
            )
            .disposed(by: disposeBag)
    }
    
    func fetchUserIfNeeded() {
        guard let accessToken = KeychainStorage.shared.getToken()?.accessToken else {
            return
        }
        
        if UserDefaults.standard.string(forKey: "username") == nil {
            useCase.getUser(token: accessToken)
                .subscribe(onNext: { [weak self] user in
                    self?.username = user.nickname
                })
                .disposed(by: disposeBag)
        }
    }
    
    func requestSetProfile(name: String) {
        print(#function, #line, "Path : # ")
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String, let url = URL(string: "\(baseURL)/user"),
        let accessToken = pendingAccessToken else {
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
                
                if let access = self?.pendingAccessToken, let refresh = self?.pendingRefreshToken {
                    self?.saveTokens(accessToken: access, refreshToken: refresh)
                    self?.pendingAccessToken = nil
                    self?.pendingRefreshToken = nil
                }
                self?.username = response.data.nickname
                self?.completed = ()
            }
        }.resume()
    }
}
