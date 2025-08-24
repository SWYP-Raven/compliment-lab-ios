//
//  AgreenmentView.swift
//  ComplimentLab
//
//  Created by CatSlave on 8/20/25.
//

import SwiftUI

private let serviceUrl = "https://morning-eustoma-934.notion.site/25134b4c56f080bb9e36c7cff0656e97?pvs=97#25134b4c56f080fbb8cef4f49cbdfe72"

private let personalUrl = "https://morning-eustoma-934.notion.site/25134b4c56f080bb9e36c7cff0656e97?pvs=97#25134b4c56f0802ca54bedb317c34092"

private let adUrl = "https://morning-eustoma-934.notion.site/25134b4c56f080bb9e36c7cff0656e97?pvs=97#25134b4c56f080fbb8cef4f49cbdfe72"

struct AgreementItem {
    let title: String
    let isRequired: Bool
    let isClickable: Bool
    let url: String?
    var isAgreed: Bool = false
}

struct AgreementView: View {
   
    let onAgreementCompleted: () -> Void
    
    @State private var agreementItems: [AgreementItem] = [
        AgreementItem(title: "만 14세 이상입니다.", isRequired: true, isClickable: false, url: nil),
        AgreementItem(title: "이용약관", isRequired: true, isClickable: true, url: serviceUrl),
        AgreementItem(title: "개인정보 보호정책", isRequired: true, isClickable: true, url: personalUrl),
        AgreementItem(title: "맞춤형 광고 및 개인정보 제공 동의", isRequired: false, isClickable: true, url: adUrl)
    ]
    
    @State private var agreeToAll: Bool = false
    @State private var showWebView = false
    @State private var selectedURL: String = ""
    
    private var allRequiredAgreed: Bool {
        agreementItems.filter { $0.isRequired }.allSatisfy { $0.isAgreed }
    }
    
    private var allItemsAgreed: Bool {
        agreementItems.allSatisfy { $0.isAgreed }
    }
    
    var body: some View {
        VStack(spacing: 32) {
            // 헤더
            VStack(spacing: 16) {
                Text("칭찬연구소에 오신 걸 환영해요")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 1.0, green: 0.4, blue: 0.7))
                Text("서비스 사용 전, 각항 정보 제공에 동의해 주세요.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            
            Rectangle()
                .fill(Color.gray2)
                .frame(height: 1)
            
            VStack(spacing: 24) {
                ForEach(agreementItems.indices, id: \.self) { index in
                    VStack(spacing: 0) {
                        HStack() {
                            HStack(spacing: 10) {
                                Text(agreementItems[index].isRequired ? "[필수]" : "[선택]")
                                    .font(.suite(.semiBold, size: 14))
                                    .foregroundColor(.gray6)
                                Button(action: {
                                    guard let url = agreementItems[index].url else { return }
                                    selectedURL = url
                                    showWebView = true
                                    print(#function, #line)
                                }) {
                                    Text(agreementItems[index].title)
                                        .font(.suite(.semiBold, size: 14))
                                        .foregroundColor(.gray6)
                                        .multilineTextAlignment(.leading)
                                        .underline(agreementItems[index].isClickable)
                                }
                                .disabled(!agreementItems[index].isClickable)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    agreementItems[index].isAgreed.toggle()
                                    updateAgreeToAll()
                                }
                            }) {
                                Image(agreementItems[index].isAgreed ? .checkNormalPressed : .checkNormalDefault)
                                    
                            }
                        }
                        .padding(.horizontal, 19.5)
                    }
                }
            }
            
            Rectangle()
                .fill(Color.gray2)
                .frame(height: 1)
            
            HStack() {
                Text("전체 동의하기")
                    .font(.suite(.regular, size: 17))
                    .foregroundColor(.gray8)
                    .frame(alignment: .leading)
                Spacer()
                
                Button(action: {
                    agreeToAll.toggle()
                    for index in agreementItems.indices {
                        agreementItems[index].isAgreed = agreeToAll
                    }
                }) {
                    Image(allItemsAgreed ? .checkPressed : .checkDefault)
                }
            }
            .padding(.horizontal, 24)
            
            Rectangle()
                .fill(Color.gray2)
                .frame(height: 1)
            
            // 확인했어요 버튼
            Button(action: {
                onAgreementCompleted()
            }) {
                Text("확인했어요")
                    .font(.suite(.bold, size: 17))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    
            }
            .background(allRequiredAgreed ? Color.blue4 : Color.blue3)
            .cornerRadius(14)
            .disabled(!allRequiredAgreed)
            .padding(.horizontal, 20)
        }
        .sheet(isPresented: $showWebView) {
            WebView(url: selectedURL)
        }
    }
    
    private func updateAgreeToAll() {
        agreeToAll = allItemsAgreed
    }
}

// MARK: - WebView for Terms & Privacy
import WebKit

struct WebView: UIViewRepresentable {
    let url: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if let url = URL(string: url) {
            webView.load(URLRequest(url: url))
        }
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

#Preview {
    AgreementView(onAgreementCompleted: {
        
    })
}


