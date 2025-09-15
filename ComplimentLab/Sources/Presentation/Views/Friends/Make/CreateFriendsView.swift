//
//  CreateFriendsView.swift
//  ComplimentLab
//
//  Created by CatSlave on 9/1/25.
//

import SwiftUI

struct FriendCreationView: View {
    @ObservedObject var friendViewModel: FriendsViewModel
    @Binding var showCreateFriends: Bool
    @State private var currentPage = 0
    @State private var selectedType: FriendType?
    @State private var showCompleteView = false
    @State private var friendName = ""
    @Environment(\.dismiss) var dismiss
    let totalPages = 2
    
    var body: some View {
        ZStack {
            switch friendViewModel.currentPage {
            case .create:
                VStack(spacing: 0) {
                    if currentPage == 0 {
                        CreateFriendTypeView(friendViewModel: friendViewModel, selectedType: $selectedType) {
                            currentPage = 1
                        }
                    } else {
                        if let selectedType {                            
                            CreateFriendNameView(friendViewModel: friendViewModel, friendName: $friendName, showCompleteView: $showCompleteView, friendType: selectedType)
                        }
                    }
                }
                .background(Color.white)
            case .complete:
                FriendCompleteView(
                    friendViewModel: friendViewModel, showCompleteView: $showCompleteView,
                    showCreateFriends: $showCreateFriends,
                    friendType: selectedType ?? .kind,
                    friendName: friendName
                )
                .transition(.identity)
            case .chat:
                ChatingView(friend: friendViewModel.friend)
            }
        }
        .customNavigationBar(
            centerView: {
                if !showCompleteView {
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
                }
            },
            leftView: {
                Button {
                    dismiss()
                } label: {
                    Image("Arrow left Default")
                }
            },
            overlay: showCompleteView
        )
    }
}
