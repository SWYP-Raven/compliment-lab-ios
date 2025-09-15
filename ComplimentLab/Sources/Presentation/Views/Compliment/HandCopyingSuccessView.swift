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
            if let dailyCompliment = complimentViewModel.dailyCompliment {
                VStack(spacing: 26) {
                    FlowerView(date: dailyCompliment.date)
                    
                    VStack(spacing: 28) {
                        Text("필사 완료")
                            .font(.suite(.bold, size: 17))
                            .foregroundStyle(Color.gray8)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text(dailyCompliment.compliment.content)
                                .font(.suite(.semiBold, size: 15))
                                .lineLimit(1)
                            ExDivider()
                        }
                    }
                    
                    HStack(spacing: 21) {
                        Image("logo home")
                        
                        Spacer()
                        
                        Button {
                            let changedArchived = !dailyCompliment.isArchived
                            complimentViewModel.toggleArchive()
                            complimentViewModel.patchCompliment(
                                isArchived: changedArchived,
                                isRead: dailyCompliment.isRead,
                                date: dailyCompliment.date
                            )
                        } label: {
                            ZStack {
                                Image("Flower Default Default")
                                
                                if dailyCompliment.isArchived {
                                    Image("Flower Pressed")
                                }
                            }
                        }
                        
                        let shareImageView = ComplimentShareView(
                            dailyCompliment: dailyCompliment
                        )
                        
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
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 17)
                .padding(.vertical, 25)
                .background(dailyCompliment.compliment.type.color2)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.bottom, 15)
                .overlay(
                    dailyCompliment.compliment.type.stickerLImage
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
        }
        .padding()
    }
}
