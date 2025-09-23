//
//  ProfileSetupView.swift
//  ComplimentLab
//
//  Created by CatSlave on 8/24/25.
//

import SwiftUI

struct ProfileSetupView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @StateObject private var toastManager = ToastManager()
    @State private var nickname: String = ""
    @State private var showToast = false
    @FocusState private var isTextFieldFocused: Bool
    @Environment(\.dismiss) private var dismiss
    
    private let maxLength = 10
    
    var body: some View {
        VStack(spacing: 0) {

            Text("닉네임을 입력해주세요")
                .font(.suite(.semiBold, size: 24))
                .foregroundColor(.pink3)
                .padding(.top, 90)
                .padding(.bottom, 48)
            
            ZStack(alignment: .leading) {
                if nickname.isEmpty {
                    Text("10글자 이내로 설정해주세요")
                        .font(.suite(.bold, size: 17))
                        .foregroundColor(.gray4)
                        .padding(.horizontal, 14)
                        .padding(.bottom, 10)
                }
                
                HStack {
                    TextField("", text: $nickname)
                        .font(.suite(.bold, size: 17))
                        .foregroundColor(.gray8)
                        .onChange(of: nickname, { _, newValue in
                            if newValue.count > maxLength {
                                nickname = String(newValue.prefix(maxLength))
                                toastManager.show(message: "닉네임은 최대 10글자예요")
                            }
                        })
                        .focused($isTextFieldFocused)
                    
                    if !nickname.isEmpty {
                        Button(action: {
                            nickname = ""
                        }) {
                            Image(.xDefault)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                        }
                        .frame(width: 24, height: 24)
                    }
                }
                .padding(.horizontal, 14)
                .padding(.bottom, 10)
                
            }
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(Color.pink1, lineWidth: 1)
                    .frame(height: 1),
                alignment: .bottom
            )
            .padding(.horizontal, 20)
            
            Spacer()

            Button(action: {
                loginViewModel.requestSetProfile(name: nickname)
            }) {
                Text("칭찬연구소 입장하기")
                    .font(.suite(.bold, size: 17))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(nickname.isEmpty ? Color.blue3 : Color.blue4)
                    )
                    .padding(.horizontal, 20)
            }
            .disabled(nickname.isEmpty)
            .padding(.bottom, 16)
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
        .contentShape(Rectangle())
        .onTapGesture {
            isTextFieldFocused = false
        }
        .background(Color.white)
        .toast(manager: toastManager)
        .onReceive(loginViewModel.$completed) { completed in
            guard completed != nil else { return }
            loginViewModel.naviToProfileEdit = false
        }
    }
}

