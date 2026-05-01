//
//  AccountManagementView.swift
//  ComplimentLab
//
//  Created by 이인호 on 9/2/25.
//

import SwiftUI

struct AccountManagementView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @Environment(\.dismiss) var dismiss
    @State var showAlert: Bool = false
    @State var alertType: AlertType = .logout
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 32) {
                HStack(spacing: 0) {
                    Image("apple logo")
                        .padding(.leading, -7)
                    Text("애플 계정")
                        .font(.suite(.bold, size: 17))
                        .foregroundStyle(Color.gray8)
                    Spacer()
                    Button {
                        alertType = .logout
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showAlert = true
                        }
                    } label: {
                        Text("로그아웃")
                            .font(.suite(.medium, size: 12))
                            .foregroundStyle(Color.gray6)
                    }
                }
                
                Divider()
                
                HStack {
                    Text("회원정보를 삭제하시겠어요?")
                        .font(.suite(.medium, size: 12))
                        .foregroundStyle(Color.gray4)
                    Spacer()
                    Button {
                        alertType = .withdraw
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showAlert = true
                        }
                    } label: {
                        Text("회원탈퇴")
                            .font(.suite(.medium, size: 12))
                            .foregroundStyle(Color.gray4)
                    }
                }
                
                Spacer()
            }
            .padding(.top, 40)
            .padding(.horizontal, 20)
            .customNavigationBar(
                leftView: {
                    Button {
                        dismiss()
                    } label: {
                        Image("Arrow left Default")
                    }
                }
            )
            
            if showAlert {
                Color.backgroundGray
                    .edgesIgnoringSafeArea(.all)
                
                CustomAlertView(showAlert: $showAlert, type: alertType)
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
                    .zIndex(1)
            }
        }
    }
}

enum AlertType {
    case logout
    case withdraw
    
    var title: String {
        switch self {
        case .logout: "로그아웃 하시겠어요?"
        case .withdraw: "서비스를 탈퇴하시겠어요?"
        }
    }
    
    var confirmTitle: String {
        switch self {
        case .logout: "로그아웃"
        case .withdraw: "네, 탈퇴할래요"
        }
    }
    
    var confirmColor: Color {
        switch self {
        case .logout: Color.blue4
        case .withdraw: Color.negative
        }
    }
}

struct CustomAlertView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @Binding var showAlert: Bool
    let type: AlertType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            Text(type.title)
                .font(.suite(.bold, size: 17))
                .foregroundStyle(Color.gray8)
            
            if type == .withdraw {
                Text("탈퇴 시 저장하신 내용과 대화는 모두 삭제되며, 복구가 불가능해요")
                    .font(.suite(.medium, size: 14))
                    .foregroundStyle(Color.gray6)
            }
            
            HStack {
                Button(action: {
                    showAlert = false
                }) {
                    Text("취소")
                        .font(.suite(.semiBold, size: 15))
                        .foregroundStyle(Color.gray8)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray2)
                        .cornerRadius(14)
                }
                
                Button(action: {
                    if type == .logout {
                        loginViewModel.logout()
                    } else {
                        loginViewModel.deleteUser()
                    }
                    showAlert = false
                }) {
                    Text(type.confirmTitle)
                        .font(.suite(.semiBold, size: 15))
                        .foregroundStyle(Color.gray0)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(type.confirmColor)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                }
            }
        }
        .padding(.vertical, 25)
        .padding(.horizontal, 17)
        .background(Color.gray0)
        .cornerRadius(15)
        .shadow(radius: 15)
        .padding(.horizontal, 20)
    }
}
