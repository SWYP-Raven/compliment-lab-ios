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
    @State private var isSheetPresented: Bool = false
    @Environment(\.dismiss) var dismiss
    var showBackButton: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            SettingNicknameView()
            
            Divider()
                .frame(height: 10)
                .overlay(Color.gray1)
            
            List {
                Section {
                    NavigationLink(destination: SettingAlertView()) {
                        Text("알림 설정")
                            .font(.suite(.bold, size: 17))
                            .foregroundStyle(Color.gray8)
                            .listRowBackground(Color.clear)
                    }
                    .listRowBackground(Color.clear)
                } footer: {
                    Divider()
                        .listRowInsets(EdgeInsets(top: -12, leading: 20, bottom: 0, trailing: 20))
                }
                .listRowSeparator(.hidden)
                
                Section {
                    ForEach(SettingItem.allCases, id: \.self) { item in
                        NavigationLink {
                            switch item {
                            case .notice:
                                EmptyView()
                            case .feedback:
                                FeedbackView()
                            case .account:
                                EmptyView()
                            }
                        } label: {
                            Text(item.rawValue)
                                .font(.suite(.bold, size: 17))
                                .foregroundStyle(Color.gray8)
                        }
                        .listRowBackground(Color.clear)
                    }
                } footer: {
                    Divider()
                        .listRowInsets(EdgeInsets(top: -12, leading: 20, bottom: 0, trailing: 20))
                }
                .listRowSeparator(.hidden)
                
                
                Section {
                    NavigationLink(destination: EmptyView()) {
                        Text("서비스 이용 약관")
                            .font(.suite(.bold, size: 17))
                            .foregroundStyle(Color.gray8)
                    }
                    .listRowBackground(Color.clear)
                    
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
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .listRowSpacing(12)
            .scrollDisabled(true)
            
            Spacer()
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

struct SettingNicknameView: View {
    @State private var isSheetPresented: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("닉네임")
                .font(.suite(.medium, size: 12))
                .foregroundStyle(Color.gray6)
            
            HStack {
                Text("나의닉네임")
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
