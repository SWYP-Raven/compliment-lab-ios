//
//  View+Extension.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/28/25.
//

import SwiftUI

extension View {
    func customNavigationBar<C: View, L: View, R: View>(
        @ViewBuilder centerView: @escaping () -> C = { EmptyView() },
        @ViewBuilder leftView: @escaping () -> L = { EmptyView() },
        @ViewBuilder rightView: @escaping () -> R
    ) -> some View {
        self.modifier(CustomNavigationBarModifier(centerView: centerView,
                                                 leftView: leftView,
                                                 rightView: rightView))
    }
}
