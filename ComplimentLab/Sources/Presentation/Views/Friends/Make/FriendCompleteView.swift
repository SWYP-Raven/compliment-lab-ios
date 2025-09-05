//
//  FriendCompleteView.swift
//  ComplimentLab
//
//  Created by CatSlave on 9/1/25.
//

import SwiftUI

struct FriendCompleteView: View {
    @Binding var showCompleteView: Bool
    @Binding var showCreateFriends: Bool
    @Environment(\.dismiss) var dismiss
    let friendType: FriendType
    let friendName: String
    
    var body: some View {
        ZStack {
            // 배경 이미지 - 타입에 따라 다름
            Image(backgroundImageName)
                .resizable()
                .ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
                // 상단 네비게이션
                HStack {
                    // 뒤로가기 버튼
                    Button(action: {
                        showCompleteView = false
                    }) {
                        Image(.arrowLeftDefault)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    
                    Spacer()
                    
                    // X 버튼
                    Button(action: {
                        showCreateFriends = false
                    }) {
                        Image(.xNormalDefault)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                Spacer()
                
                // 캐릭터 이미지
                Image(characterImageName)
                    .resizable()
                    .frame(width: 258, height: 293)
                
                // 소개글 카드
                VStack(spacing: 0) {
                    HStack {
                        HStack(spacing: 5.5) {
                            Image(flowerImageName)
                                .resizable()
                                .frame(width: 20, height: 20)
                            
                            Text(friendName)
                                .font(.suite(.bold, size: 14))
                                .foregroundColor(.black)
                            Image(flowerImageName)
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5.5)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(nameTagColor)
                        )
                        Spacer()
                    }
                    
                    // 소개 텍스트
                    HStack {
                        Text(introductionText)
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
                        .stroke(cardBorderColor, lineWidth: 1)
                )
                .padding(.horizontal, 20)
                .padding(.top, 23)

                Spacer()
                    .frame(height: 13)
                
                // 반가워 버튼
                Button(action: {
                    // 특정 액션 - 비워둠
                }) {
                    Text("반가워!")
                        .font(.suite(.bold, size: 17))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(buttonColor)
                        )
                        .padding(.horizontal, 20)
                }
                .padding(.bottom, 16)
            }
        }
    }
    
    private var backgroundImageName: String {
        switch friendType {
        case .kind:
            return "Chat background blue"
        case .energetic:
            return "Chat background yellow"
        case .studious:
            return "Chat background pink"
        case .special:
            return "Chat background violet"
        case .quiet:
            return "Chat background green"
        }
    }
    
    private var flowerImageName: String {
        switch friendType {
        case .kind:
            return "flower blue"
        case .energetic:
            return "flower yellow"
        case .studious:
            return "flower pink"
        case .special:
            return "flower violet"
        case .quiet:
            return "flower Green"
        }
    }
    
    private var nameTagColor: Color {
        switch friendType {
        case .kind:
            return .blue3
        case .energetic:
            return .yellow3
        case .studious:
            return .pink3
        case .special:
            return .violet3
        case .quiet:
            return .green3
        }
    }

    private var cardBorderColor: Color {
        switch friendType {
        case .kind:
            return .blue3
        case .energetic:
            return .yellow3
        case .studious:
            return .pink3
        case .special:
            return .violet3
        case .quiet:
            return .green3
        }
    }
    
    private var characterImageName: String {
        switch friendType {
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
    
    private var buttonColor: Color {
        switch friendType {
        case .kind:
            return .blue4
        case .energetic:
            return .yellow4
        case .studious:
            return .pink4
        case .special:
            return .violet4
        case .quiet:
            return .green4
        }
    }
    
    private var introductionText: String {
        switch friendType {
        case .kind:
            return "안녕, 유저이름\n오늘은 널 만나서 더 특별한 하루야!\n앞으로 같이 멋진 순간을 많이 만들자."
        case .energetic:
            return "안녕, 유저이름\n널 만나니까 벌써 신난다~\n지금부터 재미있게 얘기해보자!"
        case .special:
            return "안녕, 유저이름\n작은 변화도 놓치지 않는 편이야.\n네 안에서 빛나는 부분을 꼭 짚어주고 싶어."
        case .quiet:
            return "안녕, 유저이름\n첫인상부터 네 매력이 확 느껴지는데?\n우리 대화하면 금방 더 재미있어질 거야!"
        case .studious:
            return "안녕, 유저이름\n처음 만났는데도 왠지 편안하다.\n우리 차근차근 가까워지면 좋겠어:)"
        }
    }
}

#Preview {
    @State var showCompleteView = true
    @State var showCreateFriends = true
    
    FriendCompleteView(
        showCompleteView: $showCompleteView,
        showCreateFriends: $showCreateFriends,
        friendType: .kind,
        friendName: "테스트친구"
    )
}
