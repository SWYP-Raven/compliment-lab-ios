//
//  LoginView.swift
//  ComplimentLab
//
//  Created by CatSlave on 8/8/25.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @State private var currentPage = 0
    @State private var appleLoginCoordinator = AppleLoginManager()
    private let totalPages = 3
    private var isLogin: Bool { currentPage == 2 }

    var body: some View {
        NavigationStack {
            ZStack {
                onboardingContent
            }
            .onReceive(appleLoginCoordinator.$credential) { credential in
                guard let credential else { return }
                loginViewModel.loginWithApple(credential: credential)
            }
            .navigationDestination(isPresented: $loginViewModel.naviToProfileEdit) {
                ProfileSetupView()
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

            if isLogin {
                loginButtons
            } else {
                nextButton
            }
        }
        .background(Color.white)
    }

    private var loginButtons: some View {
        VStack(spacing: 12) {
            // Apple 로그인
            Button(action: performAppleLogin) {
                Label {
                    Text("Apple로 시작하기")
                        .foregroundColor(.white)
                        .font(.suite(.semiBold, size: 17))
                } icon: {
                    Image(systemName: "apple.logo")
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .cornerRadius(12)
                .padding(.horizontal, 20)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom, 15.72)
//
//            // Google 로그인
//            Button(action: {
//                loginViewModel.loginWithGoogle()
//            }) {
//                HStack(spacing: 8) {
//                    Image("google_logo") // Assets에 구글 로고 이미지 추가 필요
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 20, height: 20)
//                    Text("Google로 시작하기")
//                        .foregroundColor(.gray)
//                        .font(.suite(.semiBold, size: 17))
//                }
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(Color.white)
//                .cornerRadius(12)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 12)
//                        .stroke(Color.gray3, lineWidth: 1)
//                )
//                .padding(.horizontal, 20)
//            }
//            .buttonStyle(PlainButtonStyle())
        }
    }

    private var nextButton: some View {
        Button(action: {
            withAnimation { currentPage += 1 }
        }) {
            Text("다음")
                .foregroundColor(.white)
                .font(.suite(.semiBold, size: 17))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue3)
                .cornerRadius(12)
                .padding(.horizontal, 20)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.bottom, 15.72)
    }

    private func performAppleLogin() {
        let hashedNonce = appleLoginCoordinator.prepareNonce()
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = hashedNonce

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
