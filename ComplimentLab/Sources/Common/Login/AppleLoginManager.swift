//
//  AppleLoginManager.swift
//  ComplimentLab
//
//  Created by CatSlave on 8/20/25.
//

import Foundation
import AuthenticationServices

class AppleLoginCoordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    @Published var logged: Void?
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first { $0.isKeyWindow }!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
           let authorizationCode = credential.authorizationCode,
           let identityToken = credential.identityToken,
           let authCodeString = String(data: authorizationCode, encoding: .utf8),
           let identifyTokenString = String(data: identityToken, encoding: .utf8) {
            logged = ()
            print("authorizationCode: \(authorizationCode)")
            print("identityToken: \(identityToken)")
            print("authCodeString: \(authCodeString)")
            print("identifyTokenString: \(identifyTokenString)")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple 로그인 실패: \(error.localizedDescription)")
    }
}
