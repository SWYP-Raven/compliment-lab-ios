//
//  CustomNavigationBarModifier.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/28/25.
//

import SwiftUI

struct CustomNavigationBarModifier<C: View, L: View, R: View>: ViewModifier {
    let centerView: () -> C
    let leftView: () -> L
    let rightView: () -> R

    init(
        @ViewBuilder centerView: @escaping () -> C = { EmptyView() },
        @ViewBuilder leftView: @escaping () -> L = { EmptyView() },
        @ViewBuilder rightView: @escaping () -> R
    ) {
        self.centerView = centerView
        self.leftView = leftView
        self.rightView = rightView
    }

    func body(content: Content) -> some View {
        VStack(spacing: 18) {
            ZStack {
                HStack {
                    self.leftView()
                    
                    Spacer()
                    
                    self.rightView()
                }
                .frame(height: 24)
                .frame(maxWidth: .infinity)
                .padding(.leading, 13)
                .padding(.trailing, 20)
                .padding(.top, 6)
                
                HStack {
                    Spacer()
                    
                    self.centerView()
                    
                    Spacer()
                }
            }
            
            content
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}
