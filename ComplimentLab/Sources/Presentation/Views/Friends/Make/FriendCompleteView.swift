//
//  FriendCompleteView.swift
//  ComplimentLab
//
//  Created by CatSlave on 9/1/25.
//

import SwiftUI

struct FriendCompleteView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @ObservedObject var friendViewModel: FriendsViewModel
    @Binding var showCompleteView: Bool
    @Binding var showCreateFriends: Bool
    @Environment(\.dismiss) var dismiss
    let friendType: FriendType
    let friendName: String
    
    var body: some View {
        ZStack {
            // 배경 이미지 - 타입에 따라 다름
            friendType.chatBackground
                .resizable()
                .ignoresSafeArea(.all)
            
            VStack {
                Spacer()
                friendType.chatIntroduceImage
                    .resizable()
                    .frame(width: 258, height: 293)
                Spacer()
            }
            VStack(spacing: 0) {
                Spacer()
                // 소개글 카드
                VStack(spacing: 0) {
                    HStack {
                        HStack(spacing: 5.5) {
                            friendType.flowerImage
                                .resizable()
                                .frame(width: 20, height: 20)
                            
                            Text(friendName)
                                .font(.suite(.bold, size: 14))
                                .foregroundColor(.black)
                            
                            friendType.flowerImage
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5.5)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(friendType.color3)
                        )
                        Spacer()
                    }
                    
                    // 소개 텍스트
                    HStack {
                        Text("안녕, \(loginViewModel.username)\n\(friendType.introductionText)")
                            .font(.suite(.medium, size: 14))
                            .foregroundColor(.gray8)
                            .multilineTextAlignment(.leading)
                            .padding(.top, 8)
                        Spacer()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 11)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .stroke(friendType.color3, lineWidth: 1)
                )
                .padding(.horizontal, 20)
                .padding(.top, 23)

                Spacer()
                    .frame(height: 13)
                
                // 반가워 버튼
                
                Button(action: {
                    // 특정 액션 - 비워둠
                    withAnimation(.none) {
                        friendViewModel.currentPage = .chat
                    }
                }) {
                    Text("반가워!")
                        .font(.suite(.bold, size: 17))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(friendType.color4)
                        )
                        .padding(.horizontal, 20)
                }
                .padding(.bottom, 16)
            }
        }
    }
}
