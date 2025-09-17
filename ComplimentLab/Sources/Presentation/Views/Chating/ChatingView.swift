//
//  ChatingView.swift
//  ComplimentLab
//
//  Created by CatSlave on 9/1/25.
//

import SwiftUI

struct ChatingView: View {
    @StateObject var chatingViewModel = ChatingViewModel(useCase: ChatAPI())
    @State var message: String = ""
//    @State var makeCard: Bool = false
    @Environment(\.dismiss) var dismiss
    let friend: Friend
    
    var body: some View {
        if !chatingViewModel.makeCard {
            ZStack {
                ZStack {
                    // 배경 그라데이션
                    LinearGradient(
                        colors: [friend.type.color2, friend.type.color4],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                    .onTapGesture {
                        UIApplication.shared.endEditing(true)
                    }
                    
                    // 상단 캐릭터 이미지 영역
                    ZStack(alignment: .top) {
                        HStack {
                            Spacer()
                            
                            friend.type.stickerXLImage
                                .padding(.trailing, 24)
                        }
                        
                        // 채팅 리스트 (이미지 바로 아래 붙음)
                        VStack {
                            ScrollViewReader { proxy in
                                ScrollView {
                                    LazyVStack {
                                        ForEach(chatingViewModel.chats) { chat in
                                            ChatMessageRow(chatingViewModel: chatingViewModel, chat: chat, friendType: friend.type, isLast: chat == chatingViewModel.chats.last)
                                                .id(chat.id)
                                        }
                                    }
                                }
                                .onChange(of: chatingViewModel.chats.count) { _, _ in
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        withAnimation {
                                            proxy.scrollTo(chatingViewModel.chats.last?.id, anchor: .bottom)
                                        }
                                    }
                                }
                                .defaultScrollAnchor(
                                    chatingViewModel.chats.count > 8 ? .bottom : .top
                                )
                            }
                            .onTapGesture {
                                UIApplication.shared.endEditing(true)
                            }
                            
                            // 하단 메시지 입력 영역
                            ZStack(alignment: .trailing) {
                                TextField("메시지를 입력해주세요", text: $message, axis: .vertical)
                                    .font(.suite(.medium, size: 14))
                                    .foregroundStyle(Color.gray8)
                                    .padding(.vertical, 15)
                                    .padding(.leading, 14)
                                    .padding(.trailing, 44)
                                    .background(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(Color.gray4, lineWidth: 1)
                                    )
                                    .autocorrectionDisabled()
                                    .textInputAutocapitalization(.never)
                                
                                Button(action: {
                                    chatingViewModel.postChat(message: message, friendId: friend.id)
                                    message = ""
                                }) {
                                    Image(message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Chat Arrow up Default" : "Chat Arrow up Pressed")
                                }
                                .disabled(
                                    message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                )
                                .padding(.trailing, 4)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 16)
                        }
                        .background {
                            UnevenRoundedRectangle(
                                topLeadingRadius: 20,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 20
                            )
                            .fill(Color.white)
                            .ignoresSafeArea(edges: .bottom)
                        }
                        .padding(.top, 87)
                    }
                }
                .task {
                    chatingViewModel.getChats(friendId: friend.id)
                }
                .customNavigationBar(
                    leftView: {
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image("Arrow left Default")
                            }
                            
                            Text(friend.name)
                                .font(.suite(.bold, size: 17))
                                .foregroundStyle(Color.gray9)
                        }
                    },
                    overlay: true
                )
                
                CardAlertView(chatingViewModel: chatingViewModel)
            }
        } else {
            CardView(chatingViewModel: chatingViewModel, card: chatingViewModel.card)
        }
    }
}

struct ChatMessageRow: View {
    @ObservedObject var chatingViewModel: ChatingViewModel
    let chat: Chat
    let friendType: FriendType
    let isLast: Bool
    
    var body: some View {
        HStack {
            if chat.role == .USER {
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }
            
            if chat.role == .ASSISTANT {
                HStack(alignment: .top) {
                    friendType.emoji
                        .resizable()
                        .frame(width: 35, height: 35)
                    
                    Text(chat.message)
                        .padding()
                        .font(.suite(.medium, size: 14))
                        .background(Color.gray1)
                        .clipShape(
                            UnevenRoundedRectangle(
                                topLeadingRadius: 0,
                                bottomLeadingRadius: 15,
                                bottomTrailingRadius: 15,
                                topTrailingRadius: 15
                            )
                        )
                    
                    if isLast {
                        VStack {
                            Spacer()
                            Button {
                                chatingViewModel.showCardAlert = true
                                chatingViewModel.createCardDTO = CreateCardDTO(chatId: chat.id, message: chat.message, role: chat.role)
                            } label: {
                                friendType.cardMake
                            }
                        }
                    }
                }
                
            } else {
                Text(chat.message)
                    .padding()
                    .font(.suite(.medium, size: 14))
                    .background(friendType.color2)
                    .clipShape(
                        UnevenRoundedRectangle(
                          topLeadingRadius: 15,
                          bottomLeadingRadius: 15,
                          bottomTrailingRadius: 15,
                          topTrailingRadius: 0
                        )
                    )
            }
            
            if chat.role == .ASSISTANT {
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .padding(.top)
    }
}


struct CardAlertView: View {
    @ObservedObject var chatingViewModel: ChatingViewModel
    var body: some View {
        if chatingViewModel.showCardAlert {
            Color.backgroundGray
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    chatingViewModel.showCardAlert = false
                }
            
            VStack(spacing: 22) {
                Image("kind")
                
                Text("이 문장으로 칭찬카드를 만들까요?")
                    .font(.suite(.bold, size: 17))
                    .foregroundStyle(Color.gray8)
                
                Text("카드로 만들면 언제든 꺼내볼 수 있어요")
                    .font(.suite(.medium, size: 14))
                    .foregroundStyle(Color.gray6)
                
                HStack {
                    Button(action: {
                        chatingViewModel.showCardAlert = false
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
                        chatingViewModel.showCardAlert = false
                        chatingViewModel.makeCard = true
                        chatingViewModel.postCard(createCardDTO: chatingViewModel.createCardDTO)
                    }) {
                        Text("좋아요")
                            .font(.suite(.semiBold, size: 15))
                            .foregroundStyle(Color.gray0)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue4)
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
}

