//
//  ChatingView.swift
//  ComplimentLab
//
//  Created by CatSlave on 9/1/25.
//

import SwiftUI

struct ChatingView: View {
    @StateObject var chatingViewModel: ChatingViewModel
    @Binding var showChatingView: Bool
    let friendChating: FriendChating
    
    var body: some View {
          ZStack {
              // 배경 그라데이션
              LinearGradient(
                  colors: [backgroundColorLight, backgroundColorDark],
                  startPoint: .top,
                  endPoint: .bottom
              )
              .ignoresSafeArea()
              
              VStack(spacing: 0) {
                  // 상단 캐릭터 이미지 영역
                  HStack {
                      Spacer()
                      
                      Rectangle()
                          .fill(Color.white.opacity(0.5))
                          .frame(width: 114, height: 87)
                          .padding(.trailing, 21)
                  }
                  .padding(.top, 0) // safe area와 붙임
                  
                  // 채팅 리스트 (이미지 바로 아래 붙음)
                  List(chatingViewModel.chatingList, id: \.id) { message in
                      ChatMessageRow(message: message, friendType: friendChating.type)
                          .listRowSeparator(.hidden)
                          .listRowBackground(Color.clear)
                  }
                  .listStyle(PlainListStyle())
                  .scrollContentBackground(.hidden)
                  .background(.green)
                  
                  // 하단 메시지 입력 영역
                  HStack {
                      TextField("메시지를 입력해주세요", text: .constant(""))
                          .textFieldStyle(RoundedBorderTextFieldStyle())
                      
                      Button(action: {
                          // 전송 액션
                      }) {
                          Image(systemName: "arrow.up.circle.fill")
                              .font(.title2)
                              .foregroundColor(.blue)
                      }
                  }
                  .padding(.horizontal, 20)
                  .padding(.bottom, 16)
              }
              
              // 네비게이션 바 오버레이
              VStack {
                  HStack {
                      HStack(spacing: 8) {
                          Button(action: {
                              showChatingView = false
                          }) {
                              Image("Arrow left Default")
                                  .resizable()
                                  .frame(width: 24, height: 24)
                          }
                          
                          Text(friendChating.name)
                              .font(.suite(.bold, size: 18))
                              .foregroundColor(.black)
                      }
                      
                      Spacer()
                  }
                  .padding(.horizontal, 20)
                  .padding(.top, 16)
                  
                  Spacer()
              }
          }
          .navigationBarHidden(true)
      }
    
    // Computed Properties
    private var backgroundColorLight: Color {
        switch friendChating.type {
        case .kind:
            return Color("blue2")
        case .energetic:
            return Color("yellow2")
        case .studious:
            return Color("pink2")
        case .special:
            return Color("violet2")
        case .quiet:
            return Color("green2")
        }
    }
    
    private var backgroundColorDark: Color {
        switch friendChating.type {
        case .kind:
            return Color("blue4")
        case .energetic:
            return Color("yellow4")
        case .studious:
            return Color("pink4")
        case .special:
            return Color("violet4")
        case .quiet:
            return Color("green4")
        }
    }
    
    private var characterImageName: String {
        switch friendChating.type {
        case .kind:
            return "Chat introduce Blue"
        case .energetic:
            return "Chat introduce Yellow"
        case .studious:
            return "Chat introduce Pink"
        case .special:
            return "Chat introduce Violet"
        case .quiet:
            return "Chat introduce Green"
        }
    }
}

struct ChatMessageRow: View {
    let message: ChatMessage
    let friendType: FriendType
    
    var body: some View {
        Text(message.message)
            .padding()
            .background(Color.white.opacity(0.8))
            .cornerRadius(12)
    }
}


#Preview {
    @State var showCreateFriends = false
    
    ChatingView(chatingViewModel: .init(),
                showChatingView: $showCreateFriends,
                friendChating: .init(type: .energetic,
                                     message: "테스트",
                                     name: "캐릭터",
                                     dateString: "임시")
    )
}
