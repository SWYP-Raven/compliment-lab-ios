//
//  CustomSegmentedControl.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/17/25.
//

import SwiftUI

struct CustomSegmentedControl<T: Hashable & CustomStringConvertible>: View {
    let items: [T]
    let cornerRadius: CGFloat
    @Binding var selection: T
    @Namespace private var ns

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                let isSelected = item == selection
                
                ZStack {
                    if isSelected {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(Color.gray9)
                            .matchedGeometryEffect(id: "indicator", in: ns)
                    }
                    
                    Text(item.description)
                        .font(.suite(.medium, size: 13))
                        .padding(.vertical, 4)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(isSelected ? Color.gray0 : Color.gray6)
                }
                .contentShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                .onTapGesture {
                    withAnimation {
                        selection = item
                    }
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(Color.gray1)
        )
    }
}
