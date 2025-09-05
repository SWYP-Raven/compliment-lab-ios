//
//  CreateFriendsView.swift
//  ComplimentLab
//
//  Created by CatSlave on 9/1/25.
//

import SwiftUI

struct FriendCreationView: View {
    @Binding var showCreateFriends: Bool
    @State private var currentPage = 0
    @State private var selectedType: FriendType?
    @State private var showCompleteView = false
    @State private var friendName = ""
    let totalPages = 2
    
    var body: some View {
        ZStack {
            if showCompleteView {
                FriendCompleteView(
                    showCompleteView: $showCompleteView,
                    showCreateFriends: $showCreateFriends,
                    friendType: selectedType ?? .kind,
                    friendName: friendName
                )
                .transition(.identity)
            } else {
                VStack(spacing: 0) {
                    HStack {
                        Button(action: {
                            if currentPage == 0 {
                                showCreateFriends = false
                            } else {
                                currentPage = 0
                            }
                        }) {
                            Image("Arrow left Default")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 10) {
                            ForEach(0..<totalPages, id: \.self) { index in
                                if index == currentPage {
                                    Capsule()
                                        .fill(Color.blue4)
                                        .frame(width: 41, height: 9)
                                        .animation(.easeInOut, value: currentPage)
                                } else {
                                    Circle()
                                        .fill(Color.blue2)
                                        .frame(width: 9, height: 9)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: 24, height: 24)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    
                    if currentPage == 0 {
                        CreateFriendTypeView(selectedType: $selectedType) {
                            currentPage = 1
                        }
                    } else {
                        if let selectedType {
                            CreateFriendNameView(friendType: selectedType,
                                                 friendName: $friendName,
                                                 showCompleteView: $showCompleteView)
                        }
                    }
                }
                .background(Color.white)
            }
        }
    }
}

#Preview {
    @State var showCreateFriends = false
    FriendCreationView(showCreateFriends: $showCreateFriends)
}
