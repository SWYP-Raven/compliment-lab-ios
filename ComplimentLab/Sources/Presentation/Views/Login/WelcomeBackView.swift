//
//  WelcomeBackView.swift
//  ComplimentLab
//
//  Created by wayblemac02 on 9/23/25.
//

import SwiftUI
import AuthenticationServices

struct WelcomeBackView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @State private var appleLoginCoordinator = AppleLoginManager()
    
    var body: some View {
        VStack {
            OnboardingPageView(
                title: "다시 만나서 반가워요", 
                subtitle: "오늘 하루도\n작은 긍정과 함께해요",
                imageName: "returning user"
            )
            .padding(.top, 68)
            .padding(.bottom, 117)
            
            Spacer()
            
            Button(action: {
                performAppleLogin()
            }) {
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
        }
        .background(Color.white)
        .onReceive(appleLoginCoordinator.$token) { token in
            guard let token else { return }
            loginViewModel.loginWithApple(identityToken: token)
        }
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

#Preview {
    WelcomeBackView()
}
