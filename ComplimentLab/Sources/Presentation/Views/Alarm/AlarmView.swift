//
//  AlarmView.swift
//  ComplimentLab
//
//  Created by 이인호 on 9/7/25.
//

import SwiftUI

struct AlarmView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Spacer()
            Image("alarm flower")
            Text("조용한 하루예요\n알림이 생기면 알려드릴게요!")
                .font(.suite(.semiBold, size: 14))
                .foregroundStyle(Color.gray4)
                .multilineTextAlignment(.center)
            Spacer()
        }
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
    AlarmView()
}
