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
        @ViewBuilder rightView: @escaping () -> R = { EmptyView() },
        overlay: Bool = false
    ) -> some View {
        self.modifier(CustomNavigationBarModifier(centerView: centerView,
                                                 leftView: leftView,
                                                 rightView: rightView,
                                                 overlay: overlay))
    }
    
    func snapshotImage(
        size: CGSize = .init(width: 335, height: 485),
        scale: CGFloat = 3.0
    ) -> Image? {
        let card = self.frame(width: size.width, height: size.height)

        let r = ImageRenderer(content: card)
        r.proposedSize = .init(width: size.width, height: size.height)
        r.scale = scale
        r.isOpaque = false

        guard let ui = r.uiImage else { return nil }
        return Image(uiImage: ui)
    }
}
