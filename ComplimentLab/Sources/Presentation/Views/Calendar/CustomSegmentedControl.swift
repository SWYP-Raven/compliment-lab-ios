//
//  CustomSegmentedControl.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/17/25.
//

import SwiftUI

struct CustomSegmentedControl<T: Hashable & CustomStringConvertible>: View {
    let items: [T]
    @Binding var selection: T
    @Namespace private var ns

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                let isSelected = item == selection
                
                ZStack {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 13.5, style: .continuous)
                            .fill(Color.gray9)
                            .matchedGeometryEffect(id: "indicator", in: ns)
                    }
                    
                    Text(item.description)
                        .font(.suite(.medium, size: 13))
                        .padding(.vertical, 4)
//                        .padding(.horizontal, 11)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(isSelected ? Color.gray0 : Color.gray6)
                }
                .contentShape(RoundedRectangle(cornerRadius: 13.5, style: .continuous))
                .onTapGesture {
                    withAnimation {
                        selection = item
                    }
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 13.5, style: .continuous)
                .fill(Color.gray1)
        )
        .frame(width: 85, height: 26)
    }
}
