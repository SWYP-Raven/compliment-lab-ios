//
//  CreateFriendNameView.swift
//  ComplimentLab
//
//  Created by CatSlave on 9/1/25.
//

import SwiftUI

struct CreateFriendNameView: View {
    let friendType: FriendType
    @StateObject private var toastManager = ToastManager()
    @Binding var friendName: String
    @Binding var showCompleteView: Bool
    @State private var showToast = false
    @State private var navigateToCompleteView = false
    @FocusState private var isTextFieldFocused: Bool
    
    private let maxLength = 10
    
    var body: some View {
        VStack(spacing: 0) {

            Text("칭구의 별명을 지어주세요")
                .font(.suite(.semiBold, size: 24))
                .foregroundColor(.pink3)
                .padding(.top, 60)
                .padding(.bottom, 48)
            
            ZStack(alignment: .leading) {
                if friendName.isEmpty {
                    Text("10글자 이내로 설정해주세요")
                        .font(.suite(.bold, size: 17))
                        .foregroundColor(.gray4)
                        .padding(.horizontal, 14)
                        .padding(.bottom, 10)
                }
                
                HStack {
                    TextField("", text: $friendName)
                        .font(.suite(.bold, size: 17))
                        .foregroundColor(.gray8)
                        .onChange(of: friendName, { _, newValue in
                            if newValue.count > maxLength {
                                friendName = String(newValue.prefix(maxLength))
                                toastManager.show(message: "닉네임은 최대 10글자예요")
                            }
                        })
                        .focused($isTextFieldFocused)
                    
                    if !friendName.isEmpty {
                        Button(action: {
                            friendName = ""
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
                withAnimation(.none) {
                    showCompleteView = true
                }
            }) {
                Text("칭구 만나기")
                    .font(.suite(.bold, size: 17))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(friendName.isEmpty ? Color.blue3 : Color.blue4)
                    )
                    .padding(.horizontal, 20)
            }
            .disabled(friendName.isEmpty)
            .padding(.bottom, 16)
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
        .contentShape(Rectangle())
        .onTapGesture {
            isTextFieldFocused = false
        }
        .background(Color.white)
        .toast(manager: toastManager)
    }
}
