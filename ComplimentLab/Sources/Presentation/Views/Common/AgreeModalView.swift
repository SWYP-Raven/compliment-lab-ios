//
//  ModalGestureView.swift
//  ComplimentLab
//
//  Created by CatSlave on 8/20/25.
//

import SwiftUI

// MARK: - Custom Modal Wrapper
struct AgreeModalView<Content: View>: View {
    let content: Content
    
    @State private var backgroundOpacity: Double = 0
    @State private var contentOffset: CGFloat = UIScreen.main.bounds.height
    @State private var isDragging = false
    
    private let dismissThreshold: CGFloat = 200
    private let velocityThreshold: CGFloat = 500
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(backgroundOpacity * 0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }
            
            VStack {
                Spacer()
                
                VStack(spacing: 0) {
                    Image(.agree)
                        .padding(.bottom, 0)
                    
                    VStack(spacing: 0) {
                        Capsule()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 40, height: 5)
                            .padding(.top, 8)
                            .padding(.bottom, 12)
                        
                        content
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .background(Color.white)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                }
                .offset(y: contentOffset)
                .gesture(dragGesture)
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .onAppear {
            appear()
        }
    }

    
    // MARK: - Drag Gesture
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                contentOffset = value.translation.height
            }
            .onEnded { value in
                handleDragEnd(value: value)
            }
    }
    
    // MARK: - Gesture Handling
    private func handleDragEnd(value: DragGesture.Value) {
        let translation = value.translation.height
        let velocity = value.predictedEndTranslation.height - value.translation.height
        
        if translation > dismissThreshold || velocity > velocityThreshold {
            dismiss()
        } else {
            withAnimation(.easeOut(duration: 0.33)) {
                contentOffset = 0
            }
        }
    }
    
    // MARK: - Animations
    private func appear() {
        withAnimation(.easeOut(duration: 0.33)) {
            backgroundOpacity = 1
            contentOffset = 0
        }
    }
    
    private func dismiss() {
        withAnimation(.easeIn(duration: 0.33)) {
            backgroundOpacity = 0
            contentOffset = UIScreen.main.bounds.height
        }
    }
}

