//
//  NoticeView.swift
//  ComplimentLab
//
//  Created by wayblemac02 on 9/2/25.
//

import SwiftUI

struct NoticeView: View {
    @Environment(\.dismiss) var dismiss
    let notices: [Notice] = [
        Notice(
            id: UUID().uuidString,
            title: "🎉 [공지] 칭찬연구소 서비스 오픈 안내",
            content: """
                안녕하세요, 칭찬연구소 팀입니다.

                많은 준비와 기다림 끝에 드디어 ‘칭찬연구소’ 서비스를
                오픈하게 되었습니다!
                 칭찬연구소는 일상의 작은 긍정이 머물 수 있도록, 매일 새로운 칭찬을 만나고, 칭구와 대화하며, 마음에 남는 칭찬을 모아 나눌 수 있는 공간입니다.

                처음 시작하는 만큼 부족한 부분도 있겠지만, 여러분의 일상 속에 따뜻한 힘이 되어드리고 싶습니다. 앞으로 함께 만들어갈 칭찬연구소의 여정을 기대해 주세요.

                여러분의 하루가 작은 긍정으로 더 포근해지길 바라며, 많은 관심과 응원 부탁드립니다!
                
                칭찬연구소와 함께해주셔서 감사합니다.
                 오늘도 작은 긍정이 머무는 하루가 되길 바라며,
                칭찬연구소 팀 드림 🌷
                """,
            createdAt: Calendar.current.date(from: DateComponents(year: 2025, month: 9, day: 3))!
        )
    ]
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16) {
                ForEach(notices, id: \.self) { notice in
                    NavigationLink(destination: NoticeDetailView(notice: notice)) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(notice.title)
                                .font(.suite(.medium, size: 15))
                                .foregroundStyle(Color.gray8)
                            
                            Text(DateFormatterManager.shared.dottedDate(from: notice.createdAt))
                                .font(.suite(.medium, size: 12))
                                .foregroundStyle(Color.gray6)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
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
    }
}

#Preview {
    NoticeView()
}
