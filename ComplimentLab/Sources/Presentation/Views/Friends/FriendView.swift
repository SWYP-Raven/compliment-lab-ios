//
//  FriendsHeaderView.swift
//  ComplimentLab
//
//  Created by CatSlave on 9/1/25.
//

import SwiftUI

struct FriendView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @ObservedObject var friendViewModel: FriendsViewModel
    @State private var showCreateFriends = true
    @Binding var selection: Int
    
    var body: some View {
        VStack {
            if friendViewModel.isLoading {
                EmptyView()
            } else if friendViewModel.friends.isEmpty {
                VStack(spacing: 29) {
                    Image("firendsEmpty")
                    Text("오늘부터 작은 긍정 하나\n칭구가 함께할게요:)")
                        .font(.suite(.semiBold, size: 14))
                        .foregroundStyle(Color.gray4)
                        .multilineTextAlignment(.center) 
                    
                    NavigationLink(destination: FriendCreationView(friendViewModel: friendViewModel, showCreateFriends: $showCreateFriends)) {
                        Text("칭구 만나러 가기")
                            .padding(.vertical, 15)
                            .frame(width: 195)
                            .font(.suite(.bold, size: 17))
                            .foregroundColor(Color.gray0)
                            .background(Color.blue4)
                            .clipShape(RoundedRectangle(cornerRadius: 27))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding()
            } else {
                VStack(alignment: .leading) {
                    let hasAllTypes = Set(friendViewModel.friends.map { $0.typeId }) == Set(FriendType.allCases)
                    
                    if hasAllTypes {
                        HStack {
                            Image("Chat day")
                            
                            VStack(alignment: .leading) {
                                Text("\(loginViewModel.username)님,")
                                    .font(.suite(.bold, size: 17))
                                    .foregroundColor(Color.blue4)
                                
                                Text("오늘의 칭찬도 보러가요:)")
                                    .font(.suite(.medium, size: 14))
                                    .foregroundColor(Color.gray5)
                            }
                            .padding(.leading, 23)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.leading, 22)
                        .padding(.trailing, 15)
                        .padding(.vertical, 10)
                        .background(Color.blue1)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.horizontal, 20)
                        .onTapGesture {
                            selection = 0
                        }
                    } else {
                        NavigationLink(destination: FriendCreationView(friendViewModel: friendViewModel, showCreateFriends: $showCreateFriends)) {
                            HStack {
                                Image("Chat make S")
                                
                                Spacer()
                                
                                VStack(alignment: .leading) {
                                    Text("\(loginViewModel.username)님,")
                                        .font(.suite(.bold, size: 17))
                                        .foregroundColor(Color.pink4)
                                    
                                    Text("다른 칭구도 불러볼까요?")
                                        .font(.suite(.medium, size: 14))
                                        .foregroundColor(Color.gray5)
                                }
                                
                                Spacer()
                                
                                Image("Arrow right Default")
                                    .renderingMode(.template)
                                    .foregroundColor(Color.pink4)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.leading, 22)
                            .padding(.trailing, 15)
                            .padding(.vertical, 10)
                            .background(Color.pink1)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    List {
                        ForEach(friendViewModel.friends, id: \.self) { friend in
                            HStack {
                                friend.typeId.emoji
                                    .frame(width: 50, height: 50)
                                
                                VStack(alignment: .leading) {
                                    Text(friend.name)
                                        .font(.suite(.semiBold, size: 15))
                                        .foregroundStyle(Color.gray8)
                                    
                                    Text(friend.lastMessage.message)
                                        .font(.suite(.medium, size: 12))
                                        .foregroundStyle(Color.gray6)
                                        .lineLimit(1)
                                }
                                
                                Spacer()
                                
                                Text(DateFormatterManager.shared.chatDisplayString(from: friend.lastMessage.time))
                                    .font(.suite(.medium, size: 12))
                                    .foregroundStyle(Color.gray4)
                            }
                            .overlay {
                                NavigationLink {
                                    ChatingView(friend: friend)
                                } label: {
                                    EmptyView()
                                }
                                .opacity(0)
                            }
                            .scrollContentBackground(.hidden)
                            .listRowInsets(EdgeInsets(top: 14, leading: 20, bottom: 14, trailing: 20))
                            .listRowSeparator(.hidden)
                            .swipeActions(edge: .trailing) {
                                Button {
                                    friendViewModel.showFriendAlert = true
                                    friendViewModel.friendAlertType = .deleteFriend
                                    friendViewModel.friend = friend
                                } label: {
                                    Image("Bin red defalt")

                                }
                                .tint(Color.negative)
                            }
                        }
                    }
                    .scrollDisabled(true)
                    .listStyle(.plain)
                }
                .customNavigationBar(
                    rightView: {
                        Button {
                            
                        } label: {
                            Image("Bin defalt")
                        }
                    }
                )
            }
        }
        .task {
            friendViewModel.getFriends()
            friendViewModel.currentPage = .create
        }
    }
}

struct HeaderImageView: View {

    let message: String
    let titleColor: Color
    let arrow: ImageResource
    
    var body: some View {
        HStack(spacing: 23) {
            Image("firendsEmpty")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.leading, 22)
            
            HStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 0) {
                        Text("nickname")
                            .font(.suite(.bold, size: 17))
                            .foregroundColor(Color.blue4)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        
                        Text("님,")
                            .font(.suite(.bold, size: 17))
                            .foregroundColor(Color.blue4)
                    }
                    
                    Text(message)
                        .font(.suite(.medium, size: 14))
                        .foregroundColor(Color.gray5)
                        .lineLimit(2)
                }
                
                Spacer()

                Image(arrow)
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            .padding(.trailing, 15)
        }
        .frame(height: 85)
        .background(
            RoundedRectangle(cornerRadius: 15)
        )
    }
}

enum FriendAlertType {
    case deleteFriend
    case createCard
    
    var title: String {
        switch self {
        case .deleteFriend: "채팅방을 나가시겠습니까?"
        case .createCard: "이 문장으로 칭찬카드를 만들까요?"
        }
    }
    
    var subTitle: String {
        switch self {
        case .deleteFriend: "칭구와 대화가 모두 사라지며, 복구할 수 없어요"
        case .createCard: "카드로 만들면 언제든 꺼내볼 수 있어요"
        }
    }
    
    var confirmTitle: String {
        switch self {
        case .deleteFriend: "나가기"
        case .createCard: "좋아요"
        }
    }
    
    var confirmColor: Color {
        switch self {
        case .deleteFriend: Color.negative
        case .createCard: Color.blue4
        }
    }
}

struct FriendAlertView: View {
    @ObservedObject var friendViewModel: FriendsViewModel
    
    var body: some View {
        if friendViewModel.showFriendAlert {
            Color.backgroundGray
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    friendViewModel.showFriendAlert = false
                }
            
            VStack(spacing: 22) {
                Image("kind")
                
                Text(friendViewModel.friendAlertType.title)
                    .font(.suite(.bold, size: 17))
                    .foregroundStyle(Color.gray8)
                
                Text(friendViewModel.friendAlertType.subTitle)
                    .font(.suite(.medium, size: 14))
                    .foregroundStyle(Color.gray6)
                
                HStack {
                    Button(action: {
                        friendViewModel.showFriendAlert = false
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
                        if friendViewModel.friendAlertType == .deleteFriend {
                            withAnimation {
                                friendViewModel.deleteFriend(friendId: friendViewModel.friend.id)
                            }
                        } else {
                            
                        }
                        friendViewModel.showFriendAlert = false
                    }) {
                        Text(friendViewModel.friendAlertType.confirmTitle)
                            .font(.suite(.semiBold, size: 15))
                            .foregroundStyle(Color.gray0)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(friendViewModel.friendAlertType.confirmColor)
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
