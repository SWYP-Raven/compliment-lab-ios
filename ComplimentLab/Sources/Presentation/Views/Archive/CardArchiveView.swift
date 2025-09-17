//
//  CardArchiveView.swift
//  ComplimentLab
//
//  Created by wayblemac02 on 9/15/25.
//

import SwiftUI

struct CardArchiveView: View {
    @ObservedObject var chatingViewModel: ChatingViewModel
    @ObservedObject var archiveViewModel: ArchiveViewModel
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        if archiveViewModel.archivedCards.isEmpty {
            VStack {
                Spacer()
                Image("daily X")
                Text("마음에 드는 문장을 저장해보세요!\n곧 가득 채워질 거예요:)")
                    .font(.suite(.semiBold, size: 14))
                    .foregroundStyle(Color.gray4)
                    .multilineTextAlignment(.center)
                Spacer()
            }
        } else {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(archiveViewModel.archivedCards, id: \.self) { card in
                        NavigationLink(destination: CardView(chatingViewModel: chatingViewModel, card: card)) {
                            VStack {
                                ZStack {
                                    card.type.card
                                        .resizable()
                                        .scaledToFit()
                                    
                                    Text(card.message)
                                        .font(.suite(.medium, size: 6.2))
                                        .foregroundStyle(Color.black)
                                        .frame(width: 60)
                                        .multilineTextAlignment(.center)
                                        .offset(y: -25)
                                }
                                
                                Text("\(DateFormatterManager.shared.dayOfWeek(from: card.createdAt))")
                                    .font(.suite(.semiBold, size: 15))
                                    .foregroundStyle(Color.gray6)
                            }
                            .padding(13)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(card.type.color2)
                            )
                        }
                    }
                }
            }
        }
    }
}

