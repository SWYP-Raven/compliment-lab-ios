//
//  LoginView.swift
//  ComplimentLab
//
//  Created by CatSlave on 8/8/25.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    @State private var currentPage = 0
    @State private var appleLoginCoordinator = AppleLoginManager()
    @State private var showAgreeView: Bool = false
    @State private var naviToProfileEdit = false
    @State private var navigateToMain = false
    private let totalPages = 3
    private var isLogin: Bool { currentPage == 2 }
    
    var body: some View {
        NavigationStack {
            ZStack {
                onboardingContent

                if showAgreeView {
                    AgreeModalView(isPresented: $showAgreeView) {
                        AgreementView(onAgreementCompleted: {
                            naviToProfileEdit = true
                        })
                    }
                }
            }
            .onReceive(appleLoginCoordinator.$token) { token in
                guard let token else { return }
                loginViewModel.loginWithApple(identityToken: token)
            }
            .onReceive(loginViewModel.$isSignup) { isSignup in
                guard let isSignup else { return }
                if isSignup {
                    navigateToMain = true
                } else {
                    naviToProfileEdit = true
                }
            }
            .navigationDestination(isPresented: $naviToProfileEdit) {
                ProfileSetupView(profileSetupViewModel: .init())
            }
        }
        .toolbarVisibility(.hidden, for: .navigationBar)
    }
    
    private var onboardingContent: some View {
        VStack {
            HStack(spacing: 10) {
                ForEach(0..<totalPages, id: \.self) { index in
                    if index == currentPage {
                        Capsule()
                            .fill(Color.blue4)
                            .frame(width: 41, height: 9)
                            .animation(.easeInOut, value: currentPage)
                    } else {
                        Circle()
                            .fill(Color.blue2)
                            .frame(width: 9, height: 9)
                    }
                }
            }
            .padding(.bottom, 68)
            
            Spacer()
            
            TabView(selection: $currentPage) {
                OnboardingPageView(
                    title: "칭찬을 보아요",
                    subtitle: "매일 다른 칭찬을 만나보세요!\n직접 써볼 수도 있어요",
                    imageName: "Onboarding1"
                )
                .tag(0)
                
                OnboardingPageView(
                    title: "칭찬을 들어요",
                    subtitle: "칭찬 친구, 칭구를 만나서\n대화할 수 있어요",
                    imageName: "Onboarding2"
                )
                .tag(1)
                
                OnboardingPageView(
                    title: "칭찬을 모으고 꺼내요",
                    subtitle: "마음에 드는 칭찬은\n저장과 공유가 가능해요",
                    imageName: "Onboarding3"
                )
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .padding(.bottom, 117)
            
            Spacer()
            
            Button(action: {
                if isLogin {
                    performAppleLogin()
                } else {
                    withAnimation {
                        currentPage += 1
                    }
                }
            }) {
                Label {
                    Text(isLogin ? "Apple로 시작하기" : "다음")
                        .foregroundColor(.white)
                        .font(.suite(.semiBold, size: 17))
                } icon: {
                    if isLogin {
                        Image(systemName: "apple.logo")
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(isLogin ? Color.black : Color.blue3)
                .cornerRadius(12)
                .padding(.horizontal, 20)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom, 15.72)
        }
        .background(Color.white)
    }
    
    
    private func performAppleLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = appleLoginCoordinator
        controller.presentationContextProvider = appleLoginCoordinator
        controller.performRequests()
    }
}

struct OnboardingPageView: View {
    let title: String
    let subtitle: String
    let imageName: String
    
    var body: some View {
        VStack() {
            Spacer()
        
            Text(title)
                .font(.suite(.semiBold, size: 24))
                .foregroundColor(Color.pink3)
                .foregroundColor(.pink)
                .padding(.bottom, 20)
            
            Text(subtitle)
                .font(.suite(.semiBold, size: 14))
                .foregroundColor(Color.gray6)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 20)
                .padding(.bottom, 95)
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 257.28)
            
            Spacer()
        }
    }
}



