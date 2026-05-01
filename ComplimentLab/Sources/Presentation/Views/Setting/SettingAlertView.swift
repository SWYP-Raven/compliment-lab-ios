//
//  SettingAlertView.swift
//  ComplimentLab
//
//  Created by 이인호 on 9/1/25.
//

import SwiftUI

struct SettingAlertView: View {
    @State private var firstToggleStates: [Bool] = Array(repeating: false, count: 3)
    @State private var secondToggleStates: [Bool] = Array(repeating: false, count: 2)
    @Environment(\.dismiss) var dismiss
    
    private let firstItems = ["일력 알림", "칭구 알림", "아카이브 알림"]
    private let secondItems = ["마케팅 활용 동의", "이벤트 혜택 알림"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            ForEach(firstItems.indices, id: \.self) { index in
                Toggle(isOn: $firstToggleStates[index]) {
                    Text(firstItems[index])
                        .font(.suite(.bold, size: 17))
                }
                .tint(Color.blue4)
            }
            
            Divider()
            
            ForEach(secondItems.indices, id: \.self) { index in
                Toggle(isOn: $secondToggleStates[index]) {
                    Text(secondItems[index])
                        .font(.suite(.bold, size: 17))
                }
                .tint(Color.blue4)
            }
            
            Spacer()
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
    SettingAlertView()
}
