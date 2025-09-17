//
//  ChatMessageRow.swift
//  ComplimentLab
//
//  Created by wayblemac02 on 9/17/25.
//

import SwiftUI

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
