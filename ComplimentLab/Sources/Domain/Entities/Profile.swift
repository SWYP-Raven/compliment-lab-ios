//
//  Profile.swift
//  ComplimentLab
//
//  Created by CatSlave on 9/5/25.
//

import Foundation

// MARK: - 요청 모델
struct ProfileUpdateRequest: Codable {
    let nickname: String
    // 프로필 설정에 알람 설정이 들어갈 이유가? (백엔드에서 조정 필요한 부분)
    // 닉네임 설정 시 알람 설정값 같이 보내지 않으면 요청실패로 임시값 할당
    var friendAlarm: Bool = true
    var archiveAlarm: Bool = true
    var marketingAlarm: Bool = true
    var eventAlarm: Bool = true
}

// MARK: - 응답 모델
struct ProfileUpdateResponse: Codable {
    let success: Bool
    let code: String
    let message: String
    let data: ProfileData
}

struct ProfileData: Codable {
    let id: Int
    let nickname: String
    let email: String
    let friendAlarm: Bool
    let archiveAlarm: Bool
    let marketingAlarm: Bool
    let eventAlarm: Bool
}
