//
//  CardView.swift
//  ComplimentLab
//
//  Created by 이인호 on 9/7/25.
//

import SwiftUI

struct CardView: View {
    @ObservedObject var chatingViewModel: ChatingViewModel
    @Environment(\.dismiss) var dismiss
    let card: Card
    
    var body: some View {
        ZStack {
            card.type.chatBackground
                .resizable()
                .ignoresSafeArea(.all)
            
            VStack {
                Spacer()
                
                VStack(alignment: .trailing) {
                    cardShareView()

                    Button {
                        chatingViewModel.deleteCard(id: card.id)
                        dismiss()
                    } label: {
                        ZStack {
                            Image("Flower Default Default")
                            Image("Flower Pressed")
                        }
                    }
                }
                
                Spacer()
                
                let shareImageView = cardShareView()
                
                if let swiftUIImage = shareImageView.snapshotImage() {
                    let photo = SharePhoto(image: swiftUIImage, caption: "칭찬카드")
                    ShareLink(
                        item: photo,
                        preview: SharePreview(
                            photo.caption,
                            image: photo.image
                        )
                    ) {
                        Text("공유하기")
                            .font(.suite(.bold, size: 17))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.blue4)
                            )
                            .padding(.horizontal, 20)
                            .padding(.bottom, 16)
                    }
                }
            }
        }
        .customNavigationBar(
            leftView: {
                if !chatingViewModel.makeCard {
                    Button {
                        dismiss()
                    } label: {
                        Image("Arrow left Default")
                    }
                }
            },
            rightView: {
                if chatingViewModel.makeCard {
                    HStack {
                        Button {
                            chatingViewModel.makeCard = false
                        } label: {
                            Image("X normal Default")
                        }
                    }
                }
            },
            overlay: true
        )
    }
    
    @ViewBuilder
    func cardShareView() -> some View {
        ZStack {
            card.type.card
                .shadow(color: Color.black.opacity(0.1),
                        radius: 40,
                        x: 0,
                        y: -3)
            
            Text(card.message)
                .font(.suite(.medium, size: 14))
                .frame(width: 137)
                .multilineTextAlignment(.center)
                .offset(y: -50)
        }
    }
}
