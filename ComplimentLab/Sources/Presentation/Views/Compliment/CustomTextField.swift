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
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator

        // 커서만 보이게 설정
        textField.font = UIFont(name: "SUITE-SemiBold", size: 15)
        textField.textColor = .clear
        textField.tintColor = .label
        textField.backgroundColor = .clear

        // 불필요한 자동 기능 끔
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        
        textField.borderStyle = .none
        textField.returnKeyType = .done
        
        textField.setContentHuggingPriority(.required, for: .vertical)
        textField.setContentCompressionResistancePriority(.required, for: .vertical)
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, text: $text, textCount: $textCount, sentence: sentence)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        @Binding var textCount: Int
        let parent: CustomTextField
        let sentence: String
        
        init(parent: CustomTextField, text: Binding<String>, textCount: Binding<Int>, sentence: String) {
            _text = text
            _textCount = textCount
            self.parent = parent
            self.sentence = sentence
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            let currentText = textField.text ?? ""
            
            DispatchQueue.main.async {
                self.text = currentText
                self.textCount = currentText.count
            }
        }
    }
}
