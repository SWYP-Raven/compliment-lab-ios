//
//  HandCopyingView.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/18/25.
//

import SwiftUI

struct HandCopyingView: View {
    @StateObject var viewModel = HandCopyingViewModel()
    private let sentence: String
    
    init(sentence: String) {
        self.sentence = sentence
    }
    
    var body: some View {
        ZStack {
            Color.pink1.ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.endEditing(true)
                }
            
            VStack {
                Text("2025년")
                    .font(.suite(.bold, size: 17))
                    .foregroundStyle(Color.gray8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 18)
                    .padding(.bottom, 15)
                
                VStack(spacing: 26) {
                    Image("Character Pink Stiker L")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TracingTextView(viewModel: viewModel, sentence: sentence)
                    Image("logo home")
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 17)
                .padding(.vertical, 25)
                .background(Color.pink2)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.bottom, 15)
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
}

#Preview {
    HandCopyingView(sentence: "")
}
