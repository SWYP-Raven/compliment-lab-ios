//
//  HandCopyingSuccessView.swift
//  ComplimentLab
//
//  Created by 이인호 on 9/1/25.
//

import SwiftUI

struct HandCopyingSuccessView: View {
    @ObservedObject var complimentViewModel: ComplimentViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            VStack(spacing: 26) {
                if let dailyCompliment = complimentViewModel.dailyCompliment {
                    FlowerView(date: dailyCompliment.date)
                    
                    VStack(spacing: 28) {
                        Text("필사 완료")
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text(dailyCompliment.compliment.title)
                                .font(.suite(.semiBold, size: 15))
                                .lineLimit(1)
                            ExDivider()
                        }
                    }
                    
                    HStack(spacing: 21) {
                        Image("logo home")
                        
                        Spacer()
                        
                        Button {
                            complimentViewModel.toggleArchive()
                        } label: {
                            ZStack {
                                Image("Flower Default Default")
                                
                                // TODO: - 아카이브
                                if dailyCompliment.isArchived {
                                    Image("Flower Pressed")
                                }
                            }
                        }
                        
                        let shareImageView = ComplimentShareView(date: dailyCompliment.date, sentence: dailyCompliment.compliment.title)
                        
                        if let swiftUIImage = shareImageView.snapshotImage() {
                            let photo = SharePhoto(image: swiftUIImage, caption: "오늘의 칭찬")
                            ShareLink(
                                item: photo,
                                preview: SharePreview(
                                    photo.caption,
                                    image: photo.image
                                )
                            ) {
                                Image("Send Default")
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 17)
            .padding(.vertical, 25)
            .background(Color.pink2)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(.bottom, 15)
            .overlay(
                Image("Character Pink Stiker L")
                    .padding(.top, 25)
                    .padding(.leading, 17),
                alignment: .topLeading
            )
                
            
            // 홈으로 돌아가기
            Button {
                complimentViewModel.copyingSuccess = false
                dismiss()
            } label: {
                Image("X Background Default")
            }
        }
        .padding()
    }
    
}
