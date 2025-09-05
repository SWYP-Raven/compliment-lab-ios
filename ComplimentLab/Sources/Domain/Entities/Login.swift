//
//  Login.swift
//  ComplimentLab
//
//  Created by CatSlave on 9/5/25.
//

import Foundation

struct LoginRequest: Codable {
    let identityToken: String
}

struct LoginResponse: Codable {
    let success: Bool
    let message: String
    let data: LoginData
}

struct LoginData: Codable {
    let userId: Int
    let isSignup: Bool
    let accessToken: String
    let refreshToken: String
}
