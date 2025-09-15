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
    let overlay: Bool

    init(
        @ViewBuilder centerView: @escaping () -> C = { EmptyView() },
        @ViewBuilder leftView: @escaping () -> L = { EmptyView() },
        @ViewBuilder rightView: @escaping () -> R = { EmptyView() },
        overlay: Bool = false,
    ) {
        self.centerView = centerView
        self.leftView = leftView
        self.rightView = rightView
        self.overlay = overlay
    }

    func body(content: Content) -> some View {
        Group {
            if overlay {
                ZStack(alignment: .top) {
                    content
                    
                    navBar
                }
            } else {
                VStack(spacing: 18) {
                    navBar
                    content
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    @ViewBuilder
    private var navBar: some View {
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
    }
}
