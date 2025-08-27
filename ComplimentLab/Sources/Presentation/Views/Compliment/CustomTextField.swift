//
//  CustomTextField.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/24/25.
//

import Foundation
import SwiftUI

struct CustomTextField: UIViewRepresentable {
    @Binding var text: String
    @Binding var textCount: Int
    let sentence: String
    let tagIndex: Int
    var onReturn: (() -> Void)? = nil
    
    func makeUIView(context: Context) -> MyTextField {
        let textField = MyTextField()
        textField.delegate = context.coordinator
        textField.backspaceDelegate = context.coordinator

        // 커서만 보이게 설정
        textField.font = UIFont(name: "SUITE-SemiBold", size: 15)
        textField.textColor = .clear
        textField.tintColor = .label
        textField.backgroundColor = .clear

        // 불필요한 자동 기능 끔
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        
        textField.tag = tagIndex
        TextFieldRegistry.set(textField, tag: tagIndex)
        
        textField.borderStyle = .none
        textField.contentVerticalAlignment = .top
        textField.returnKeyType = .done
        
        textField.setContentHuggingPriority(.required, for: .vertical)
        textField.setContentCompressionResistancePriority(.required, for: .vertical)
        
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        return textField
    }
    
    func updateUIView(_ uiView: MyTextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, text: $text, textCount: $textCount, sentence: sentence, tagIndex: tagIndex)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate, BackspaceDelegate {
        @Binding var text: String
        @Binding var textCount: Int
        let parent: CustomTextField
        let sentence: String
        let tagIndex: Int

        private var advanceWorkItem: DispatchWorkItem?
        
        init(parent: CustomTextField, text: Binding<String>, textCount: Binding<Int>, sentence: String, tagIndex: Int) {
            _text = text
            _textCount = textCount
            self.parent = parent
            self.sentence = sentence
            self.tagIndex = tagIndex
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            let currentText = textField.text ?? ""
            
            DispatchQueue.main.async {
                self.text = currentText
                self.textCount = currentText.count
            }
        }
        
        // 해당 라인의 문장 길이 초과 시 다음 라인으로 이동
        @objc func textFieldDidChange(_ textField: UITextField) {
            let targetLen = sentence.precomposedStringWithCanonicalMapping.count
            let currentText = (textField.text ?? "").precomposedStringWithCanonicalMapping
            
            let caretOffsetNow: Int = {
                guard let sel = textField.selectedTextRange else { return currentText.count }
                return textField.offset(from: textField.beginningOfDocument, to: sel.start)
            }()
            
            // 초과 입력이면: 원래 텍스트로 되돌리고 커서도 복원
            if currentText.count > targetLen {
                let prev = text.precomposedStringWithCanonicalMapping
                
                let delta = max(0, currentText.count - prev.count)
                
                // 되돌린 뒤 커서가 있어야 할 위치(이전 위치로 되돌리기)
                let desiredOffset = min(max(0, caretOffsetNow - delta), prev.count)
                
                // 텍스트 되돌리기
                textField.text = prev
                
                // 커서 복원
                if let start = textField.position(from: textField.beginningOfDocument, offset: desiredOffset),
                   let range = textField.textRange(from: start, to: start) {
                    textField.selectedTextRange = range
                }
                
                return
            }
            
            let isCursorAtEnd: Bool = {
                guard let sel = textField.selectedTextRange else { return true }
                return sel.end == textField.endOfDocument
            }()
            
            if currentText.count == targetLen, isCursorAtEnd {
                DispatchQueue.main.async {
                    let nextTag = textField.tag + 1
                    if let next = textField.window?.viewWithTag(nextTag) as? UITextField {
                        next.becomeFirstResponder()
                    }
                }
            }
        }
        
        // 공백이 아닌 경우에서 공백 입력 시 붉은색으로 나타내기 위함
        func textField(_ textField: UITextField,
                       shouldChangeCharactersIn range: NSRange,
                       replacementString string: String) -> Bool {
            if string == " " {
                let currentText = textField.text ?? ""
                
                guard let r = Range(range, in: currentText) else { return true }
                
                // sentence에서 해당 위치가 공백/개행이 아니면 U+3000으로 대체
                let target = sentence.precomposedStringWithCanonicalMapping
                let pos = range.location
                if pos < target.count {
                    let ch = Array(target)[pos]
                    if ch != " " && ch != "\n" {
                        let replaced = currentText.replacingCharacters(in: r, with: "\u{3000}")
                        textField.text = replaced
                        
                        if let start = textField.position(from: textField.beginningOfDocument, offset: pos + 1) {
                            textField.selectedTextRange = textField.textRange(from: start, to: start)
                        }
                        
                        return false
                    }
                }
            }
            
            return true
        }
        
        // 키보드 완료 버튼 클릭 시
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            parent.onReturn?()
            return true
        }
        
        // textField가 비어있을 때 백스페이스를 누르는 경우 처리
        func didPressBackspace(_ textField: MyTextField) {
            guard (textField.text ?? "").isEmpty else { return }
            
            // 이전 라인으로 돌아가게
            let prevTag = textField.tag - 1
            if let prev = TextFieldRegistry.get(prevTag) {
                DispatchQueue.main.async {
                    prev.becomeFirstResponder()
                }
            }
        }
    }
}

protocol BackspaceDelegate: AnyObject {
    func didPressBackspace(_ textField: MyTextField)
}

class MyTextField: UITextField {
    weak var backspaceDelegate: BackspaceDelegate?

    override func deleteBackward() {
        super.deleteBackward()
        backspaceDelegate?.didPressBackspace(self)
    }
}

class TextFieldRegistry {
    static var map: [Int: WeakRef<UITextField>] = [:]
    static func set(_ tf: UITextField, tag: Int) { map[tag] = WeakRef(tf) }
    static func get(_ tag: Int) -> UITextField? { map[tag]?.value }
}

class WeakRef<T: AnyObject> {
    weak var value: T?
    init(_ v: T) { self.value = v }
}
