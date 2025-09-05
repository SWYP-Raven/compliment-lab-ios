//
//  FriendsHeaderView.swift
//  ComplimentLab
//
//  Created by CatSlave on 9/1/25.
//

import SwiftUI

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

