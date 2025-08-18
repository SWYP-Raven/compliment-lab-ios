//
//  TodayComplimentView.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/18/25.
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

struct TodayComplimentView: View {
    var body: some View {
        ZStack {
            Color.pink1.ignoresSafeArea()
            
            VStack {
                Text("2025년")
                    .font(.suite(.bold, size: 17))
                    .foregroundStyle(Color.gray8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 18)
                    .padding(.bottom, 15)
                
                VStack(spacing: 26) {
                    FlowerView()
                    
                    VStack(spacing: 28) {
                        ComplimentTextView()
                        Image("logo home")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 17)
                .padding(.vertical, 25)
                .background(Color.pink2)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.bottom, 15)
                .overlay(
                    Image("Character Pink Stiker L")
                        .padding(.top, 25)
                        .padding(.leading, 17),
                    alignment: .topLeading
                )
                
                HStack(spacing: 21) {
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        ZStack {
                            Image("Flower Default Default")
                            
                            // TODO: - If 필사 완료했을때?
                            Image("Flower Pressed")
                        }
                    }
                
                    Button {
                        
                    } label: {
                        Image("Send Default")
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
}

struct FlowerView: View {
    var body: some View {
        VStack {
            Image("flower")
                .resizable()
                .scaledToFit()
                .frame(height: 260)
                .overlay(
                    VStack {
                        Text("August")
                            .font(.suite(.bold, size: 17))
                            .foregroundStyle(Color.gray6)
                        Text("09")
                            .font(.suite(.heavy, size: 128))
                            .foregroundStyle(Color.gray10)
                    },
                    alignment: .center
                )
                .padding(.top, 43)
        }
    }
}

struct ComplimentTextView: View {
    let message: String = "오늘도 한 발자국 나아갔네요.\n그 걸음이 모여 더 큰 변화를 만들 거예요!"
    
    var body: some View {
        VStack(spacing: 12) {
            ExDivider()
            ForEach(lines, id: \.self) { line in
                Text(line)
                if line != lines.last {
                    ExDivider()
                }
            }
            ExDivider()
        }
    }
    
    private var lines: [String] {
        message.components(separatedBy: "\n")
    }
}

#Preview {
    TodayComplimentView()
}
