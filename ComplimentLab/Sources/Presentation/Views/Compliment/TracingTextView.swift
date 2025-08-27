//
//  TracingTextView.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/24/25.
//

import SwiftUI

struct TracingTextView: View {
    @ObservedObject var viewModel: HandCopyingViewModel
    @ObservedObject var toastManager: ToastManager
    @State private var texts: [String]
    @State private var textCounts: [Int]
    private let sentence: String
    private let lines: [String]

    init(viewModel: HandCopyingViewModel, toastManager: ToastManager, sentence: String) {
        self.viewModel = viewModel
        self.toastManager = toastManager
        self.sentence = sentence.precomposedStringWithCanonicalMapping
        self.lines = sentence.components(separatedBy: "\n")
        _texts = State(initialValue: Array(repeating: "", count: lines.count))
        _textCounts = State(initialValue: Array(repeating: 0, count: lines.count))
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ExDivider()
            
            ForEach(lines.indices, id: \.self) { i in
                let line = lines[i]
                let target = line.precomposedStringWithCanonicalMapping
                let inputNFC = texts[i].precomposedStringWithCanonicalMapping
                let committed = String(inputNFC.prefix(min(textCounts[i], target.count)))
                let overlay = buildOverlayTextAttributed(target: line,
                                                         committed: committed)
                let textWidth = String(overlay.characters)
                    .singleLineWidth(using: UIFont(name: "SUITE-SemiBold", size: 15)!) + 1
                
                // 2) 화면에 렌더링할 Attributed Text 구성
                ZStack {
                    Text(overlay)
                        .font(.suite(.semiBold, size: 15))
                        .allowsHitTesting(false) // 터치 제스처 막기
                    
                    // 실제 입력 필드 (텍스트는 숨기고 커서만 표시)
                    CustomTextField(
                        text: $texts[i],
                        textCount: $textCounts[i],
                        sentence: line,
                        tagIndex: i,
                        onReturn: {
                            validateHandCopying()
                        }
                    )
                    .frame(width: textWidth)
                }
                
                if line != lines.last {
                    ExDivider()
                }
            }
            
            ExDivider()
        }
    }
    
    private func validateHandCopying() {
        let fullInput = texts.joined(separator: "\n").precomposedStringWithCanonicalMapping
        
        if fullInput.count == sentence.count {
            if fullInput == sentence {
                print("동일")
            } else {
                toastManager.show(message: "조금 다르네요, 다시 해볼까요?")
            }
        } else {
            toastManager.show(message: "더 입력해주면 완성할 수 있어요!")
        }
    }
    
    // MARK: Overlay builder
    private func buildOverlayTextAttributed(target: String, committed: String) -> AttributedString {
        var a = AttributedString("")

        let targetChars = Array(target)
        let committedChars = Array(committed)
        let judgedCount = max(0, committedChars.count - 1)

        // 확정 구간(입력중인 글자 전까지)
        for i in 0..<min(judgedCount, targetChars.count) {
            let ok = committedChars[i] == targetChars[i]
            let char: Character
            let color: Color
            
            if !ok && committedChars[i] == "\u{3000}" {
                char = targetChars[i]
                color = .red
            } else {
                char = committedChars[i]
                color = ok ? .primary : .red
            }
            var seg = AttributedString(String(char))
            seg.foregroundColor = color
            a += seg
        }

        // 입력중인 글자
        if committedChars.count > 0, judgedCount < committedChars.count {
            let current = committedChars[judgedCount]
            let target = targetChars[judgedCount]
            let nextTgt: Character? = (judgedCount + 1 < targetChars.count) ? targetChars[judgedCount + 1] : nil
            let ok = viewModel.isAcceptablePrefix(target: target, input: current, nextTarget: nextTgt)
            
            let char: Character
            let color: Color
            
            if !ok && current == "\u{3000}" {
                char = target
                color = .red
            } else {
                char = current
                color = ok ? .primary : .red
            }
            var seg = AttributedString(String(char))
            seg.foregroundColor = color
            a += seg
        }

        // 남은 문장
        if committedChars.count < targetChars.count {
            var seg = AttributedString(String(targetChars.dropFirst(committedChars.count)))
            seg.foregroundColor = .secondary
            a += seg
        }

        return a
    }
}

#Preview {
    TracingTextView(viewModel: HandCopyingViewModel(), toastManager: ToastManager(), sentence: "")
}
