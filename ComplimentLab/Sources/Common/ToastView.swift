//
//  ToastView.swift
//  ComplimentLab
//
//  Created by CatSlave on 8/24/25.
//

import SwiftUI

// MARK: - Toast Manager
class ToastManager: ObservableObject {
    @Published var isShowing = false
    @Published var message = ""
    private var workItem: DispatchWorkItem?
    
    func show(message: String, duration: Double = 1.0) {
        // 기존 작업 취소
        workItem?.cancel()
        
        // 메시지 업데이트
        self.message = message
        
        // 즉시 표시
        withAnimation(.easeInOut(duration: 0.3)) {
            isShowing = true
        }
        
        // 새로운 작업 생성
        let task = DispatchWorkItem { [weak self] in
            withAnimation(.easeOut(duration: 0.3)) {
                self?.isShowing = false
            }
        }
        
        workItem = task
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: task)
    }
}

// MARK: - Toast View
struct ToastView: View {
    let message: String
    let imageTitle: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(imageTitle)
            
            Text(message)
                .font(.suite(.semiBold, size: 15))
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.backgroundGray)
        )
    }
}

// MARK: - Toast Modifier
struct ToastModifier: ViewModifier {
    @ObservedObject var toastManager: ToastManager
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if toastManager.isShowing {
                VStack {
                    ToastView(message: toastManager.message, imageTitle: "Check Nagative Toast")
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                        .padding(.top, 6)
                        .padding(.horizontal, 20)
                    Spacer()
                }
                .animation(.easeInOut(duration: 0.3), value: toastManager.isShowing)
            }
        }
    }
}

// MARK: - View Extension
extension View {
    func toast(manager: ToastManager) -> some View {
        self.modifier(ToastModifier(toastManager: manager))
    }
}
