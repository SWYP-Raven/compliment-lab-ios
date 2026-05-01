//
//  FeedbackView.swift
//  ComplimentLab
//
//  Created by 이인호 on 9/1/25.
//

import SwiftUI

struct FeedbackView: View {
    @StateObject private var toastManager = ToastManager()
    @State private var feedbackText: String = ""
    @State private var placeholder = "함께 만드는 칭찬연구소.\n의견은 50자 이내로 적어주세요."
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                if feedbackText.isEmpty {
                    TextEditor(text: $placeholder)
                        .font(.suite(.semiBold, size: 15))
                        .foregroundColor(Color.gray4)
                        .lineSpacing(10.5)
                        .disabled(true)
                        .padding(.horizontal, 17)
                        .padding(.vertical, 25)
                }
                
                TextEditor(text: $feedbackText)
                    .frame(height: 102.5)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, 17)
                    .padding(.vertical, 25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.pink2, lineWidth: 1)
                    )
                    .overlay(
                        Image("X Default")
                            .padding([.bottom, .trailing]),
                        alignment: .bottomTrailing
                    )
                    .onChange(of: feedbackText) { _, newValue in
                        if newValue.count > 50 {
                            feedbackText = String(newValue.prefix(50))
                            toastManager.show(message: "50글자까지만 제보가 가능해요")
                        }
                    }
            }
            
            Spacer()
            Button {
                dismiss()
            } label: {
                Text("피드백 제보하기")
                    .font(.suite(.bold, size: 17))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color.gray0)
                    .background(Color.blue4)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(feedbackText.isEmpty)
        }
        .padding(.horizontal, 20)
        .padding(.top, 40)
        .padding(.bottom, 16)
        .customNavigationBar(
            leftView: {
                Button {
                    dismiss()
                } label: {
                    Image("Arrow left Default")
                }
            }
        )
        .contentShape(Rectangle())
        .onTapGesture {
            UIApplication.shared.endEditing(true)
        }
        .toast(manager: toastManager)
    }
}

#Preview {
    FeedbackView()
}
