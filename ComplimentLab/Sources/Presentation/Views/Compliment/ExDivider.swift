//
//  ExDivider.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/24/25.
//

import SwiftUI

struct ExDivider: View {
    let color: Color = .white
    let width: CGFloat = 1
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: width)
            .edgesIgnoringSafeArea(.horizontal)
    }
}

#Preview {
    ExDivider()
}
