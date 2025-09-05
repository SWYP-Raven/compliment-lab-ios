//
//  HandCopyingView.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/18/25.
//

import SwiftUI

struct HandCopyingView: View {
    @ObservedObject var complimentViewModel: ComplimentViewModel
    @StateObject private var toastManager = ToastManager()
//    @Binding var dailyCompliment: DailyCompliment

    var body: some View {
        ZStack {
            if let dailyCompliment = complimentViewModel.dailyCompliment {
                dailyCompliment.compliment.type.color1.ignoresSafeArea()
                    .onTapGesture {
                        UIApplication.shared.endEditing(true)
                    }
                
                VStack {
                    YearHeaderView(date: dailyCompliment.date)
                    
                    VStack(spacing: 26) {
                        dailyCompliment.compliment.type.stickerLImage
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TracingTextView(viewModel: complimentViewModel, toastManager: toastManager, sentence: dailyCompliment.compliment.content)
                        Image("logo home")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 17)
                    .padding(.vertical, 25)
                    .background(dailyCompliment.compliment.type.color2)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.bottom, 15)
                    
                    Spacer()
                    
                    if toastManager.isShowing {
                        ToastView(message: toastManager.message, imageTitle: "Check Toast")
                            .padding(.bottom, 22)
                    }
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            
            if complimentViewModel.copyingSuccess {
                Color.backgroundGray
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HandCopyingSuccessView(complimentViewModel: complimentViewModel)
                }
            }
        }
    }
}
