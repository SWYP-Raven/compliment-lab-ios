//
//  AccountManagementView.swift
//  ComplimentLab
//
//  Created by wayblemac02 on 9/2/25.
//

import SwiftUI

struct AccountManagementView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            HStack {
                Image("apple logo")
                    .padding(.leading, -7)
                Text("Email")
                Spacer()
                Button {
                    
                } label: {
                    Text("로그아웃")
                        .font(.suite(.medium, size: 12))
                        .foregroundStyle(Color.gray6)
                }
            }
            
            Divider()
            
            HStack {
                Text("회원정보를 삭제하시겠어요?")
                    .font(.suite(.medium, size: 12))
                    .foregroundStyle(Color.gray4)
                Spacer()
                Button {
                    
                } label: {
                    Text("회원탈퇴")
                        .font(.suite(.medium, size: 12))
                        .foregroundStyle(Color.gray4)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    AccountManagementView()
}
