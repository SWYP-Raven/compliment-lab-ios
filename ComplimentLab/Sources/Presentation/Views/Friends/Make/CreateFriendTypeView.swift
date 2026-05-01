//
//  CreateFriendTypeView.swift
//  ComplimentLab
//
//  Created by CatSlave on 9/1/25.
//

import SwiftUI

struct CreateFriendTypeView: View {
    @ObservedObject var friendViewModel: FriendViewModel
    @Binding var selectedType: FriendType?
    let onNext: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Text("어떤 성격의 칭구를 원하세요?")
                .font(.suite(.semiBold, size: 24))
                .foregroundColor(.pink4)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 20)
                .padding(.top, 32)
            
            VStack(spacing: 0) {
                let existingTypes = Set(friendViewModel.friends.map { $0.type })
                let availableTypes = FriendType.allCases.filter { !existingTypes.contains($0) }
                
                ForEach(availableTypes, id: \.self) { friendType in
                    FriendTypeRow(
                        friendType: friendType,
                        isSelected: selectedType == friendType
                    ) {
                        selectedType = friendType
                    }
                }
            }
            .padding(.top, 32)
            
            Spacer()
            
            Button(action: {
                if selectedType != nil {
                    onNext()
                }
            }) {
                Text("다음")
                    .font(.suite(.bold, size: 17))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(selectedType != nil ? Color.blue4 : Color.blue3)
                    )
            }
            .disabled(selectedType == nil)
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
    }
}

struct FriendTypeRow: View {
    let friendType: FriendType
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(friendType.title)
                        .font(.suite(.bold, size: 17))
                        .foregroundColor(.gray8)
                    
                    Text(friendType.description)
                        .font(.suite(.medium, size: 13))
                        .foregroundColor(.gray6)
                }
                
                Spacer()
            }
            .padding(.leading, 22)
            .padding(.vertical, 16)
        }
        .background(
           RoundedRectangle(cornerRadius: 12)
               .fill(isSelected ? Color.gray2 : Color.gray1)
               .stroke(isSelected ? Color.gray5 : Color.clear, lineWidth: 1)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
    }
}
