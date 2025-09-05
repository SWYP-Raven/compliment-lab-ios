//
//  SettingView.swift
//  ComplimentLab
//
//  Created by 이인호 on 9/1/25.
//

import SwiftUI

enum SettingItem: String, CaseIterable {
    case notice = "공지사항"
    case feedback = "피드백 제보"
    case account = "계정 관리"
}

struct SettingView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @State private var isSheetPresented: Bool = false
    @Environment(\.dismiss) var dismiss
    var showBackButton: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            SettingNicknameView()
            
            Divider()
                .frame(height: 10)
                .overlay(Color.gray1)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    SettingRow(title: "알림 설정", destination: AnyView(SettingAlertView()))

                    Divider()
                    
                    ForEach(SettingItem.allCases, id: \.self) { item in
                        SettingRow(
                            title: item.rawValue,
                            destination: AnyView(
                                Group {
                                    switch item {
                                    case .notice:
                                        NoticeView()
                                    case .feedback:
                                        FeedbackView()
                                    case .account:
                                        AccountManagementView()
                                    }
                                }
                            )
                        )
                    }
                    
                    Divider()

                    HStack {
                        Text("앱 버전 정보")
                            .font(.suite(.bold, size: 17))
                            .foregroundStyle(Color.gray8)
                        Text("V1.0.0")
                            .font(.suite(.medium, size: 12))
                            .foregroundStyle(Color.gray6)
                        Spacer()
                        Text("최신 버전")
                            .font(.suite(.medium, size: 12))
                            .foregroundStyle(Color.gray8)
                    }
                }
            }
            .scrollDisabled(true)
            .padding(.horizontal, 20)
        }
        .customNavigationBar(
            leftView: {
                if showBackButton {
                    Button {
                        dismiss()
                    } label: {
                        Image("Arrow left Default")
                    }
                }
            }
        )
    }
}

struct SettingRow: View {
    let title: String
    let destination: AnyView
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Text(title)
                    .font(.suite(.bold, size: 17))
                    .foregroundStyle(Color.gray8)
                Spacer()
                Image("My Arrow right Default")
                    .padding(.trailing, -7)
            }
        }
    }
}

struct SettingNicknameView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @State private var isSheetPresented: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("닉네임")
                .font(.suite(.medium, size: 12))
                .foregroundStyle(Color.gray6)
            
            HStack {
                Text("\(loginViewModel.username)")
                    .font(.suite(.semiBold, size: 24))
                    .foregroundStyle(Color.gray8)
                
                Button {
                    // 딜레이 없이 키보드 바로 띄우기
                    var trans = Transaction()
                    trans.disablesAnimations = true
                    
                    withTransaction(trans) {
                        isSheetPresented = true
                    }
                } label: {
                    Image("Edit defalt")
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .sheet(isPresented: $isSheetPresented) {
            NicknameEditView()
                .presentationDragIndicator(.visible)
                .presentationDetents([.fraction(0.3)])
        }
    }
}

struct NicknameEditView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @FocusState private var isFocused: Bool
    @State private var text: String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            Text("닉네임")
                .font(.suite(.semiBold, size: 20))
            
            ZStack(alignment: .trailing) {
                TextField("10글자 이내로 설정해주세요", text: $text)
                    .font(.suite(.bold, size: 17))
                    .focused($isFocused)
                
                Button {
                    text = ""
                } label: {
                    Image("X Default")
                }
            }
            
            Divider()
                .frame(height: 2)
                .overlay(text.isEmpty ? Color.gray4 : Color.pink2)
                .padding(.bottom, 47)
            
            Button {
                loginViewModel.editUser(nickname: text)
                dismiss()
            } label: {
                Text("작성 완료")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .font(.suite(.bold, size: 17))
                    .foregroundStyle(.white)
                    .background(Color.blue4)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(text.isEmpty)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 22)
        .onAppear {
            withAnimation {
                isFocused = true
            }
        }
    }
}

#Preview {
    SettingView()
}
