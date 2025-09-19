//
//  NoticeDetailView.swift
//  ComplimentLab
//
//  Created by 이인호 on 9/2/25.
//

import SwiftUI

struct NoticeDetailView: View {
    @Environment(\.dismiss) var dismiss
    let notice: Notice
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(notice.content)
                .font(.suite(.medium, size: 13))
                .foregroundStyle(Color.gray8)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        }
        .padding(.top, 40)
        .padding(.horizontal, 20)
        .customNavigationBar(
            centerView: {
                Text(notice.title)
                    .font(.suite(.medium, size: 15))
                    .foregroundStyle(Color.gray8)
            },
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
