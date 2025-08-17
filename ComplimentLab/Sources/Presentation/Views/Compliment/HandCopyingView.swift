//
//  HandCopyingView.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/18/25.
//

import SwiftUI

struct HandCopyingView: View {
    @State private var text = ""
    private let placeholder = "오늘도 한 발자국 나아갔네요."
    
    var body: some View {
        ZStack(alignment: .leading) {
            let p = placeholder.precomposedStringWithCanonicalMapping
            let t = text.precomposedStringWithCanonicalMapping

            let limited = String(t.prefix(p.count))

            let n = limited.count
            let matchCount: Int = {
                var c = 0
                for (a, b) in zip(limited, p.prefix(n)) {
                    if a == b { c += 1 } else { break }
                }
                return c
            }()

            let matchedPrefix   = String(limited.prefix(matchCount))
            let mismatchedInput = String(limited.dropFirst(matchCount))
            let remainingGhost  = String(p.dropFirst(n))

            (
                Text(matchedPrefix).foregroundStyle(.primary) +
                Text(mismatchedInput).foregroundStyle(.secondary) +
                Text(remainingGhost).foregroundStyle(.secondary)
            )
            .allowsHitTesting(false)

            TextField("", text: $text)
                .foregroundStyle(.clear)
                .tint(.blue)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .onChange(of: text) { _, newValue in
                    if newValue.count > p.count {
                        text = String(newValue.prefix(p.count))
                    }
                }
        }
        .padding()
    }
}

#Preview {
    HandCopyingView()
}
