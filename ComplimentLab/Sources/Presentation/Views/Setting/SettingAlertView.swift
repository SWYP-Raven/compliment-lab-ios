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
    
    private let firstItems = ["일력 알림", "칭구 알림", "아카이브 알림"]
    private let secondItems = ["마케팅 활용 동의", "이벤트 혜택 알림"]
    
    var body: some View {
        List {
            Section {
                ForEach(firstItems.indices, id: \.self) { index in
                    Toggle(isOn: $firstToggleStates[index]) {
                        Text(firstItems[index])
                            .font(.suite(.bold, size: 17))
                    }
                }
            } footer: {
                Divider()
                    .listRowInsets(EdgeInsets(top: -12, leading: 20, bottom: 0, trailing: 20))
            }
            .listRowSeparator(.hidden)
            
            Section {
                ForEach(secondItems.indices, id: \.self) { index in
                    Toggle(isOn: $secondToggleStates[index]) {
                        Text(secondItems[index])
                            .font(.suite(.bold, size: 17))
                    }
                }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .listRowSpacing(12)
        .scrollDisabled(true)
        .padding(.top, 40)
    }
}

#Preview {
    SettingAlertView()
}
