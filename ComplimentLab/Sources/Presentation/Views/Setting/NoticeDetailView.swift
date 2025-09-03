//
//  NoticeDetailView.swift
//  ComplimentLab
//
//  Created by wayblemac02 on 9/2/25.
//

import SwiftUI

struct NoticeDetailView: View {
    let notice: Notice
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(notice.content)
                .font(.suite(.medium, size: 13))
                .foregroundStyle(Color.gray8)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        }
        .padding(.horizontal, 20)
        .navigationTitle(notice.title)
    }
}
