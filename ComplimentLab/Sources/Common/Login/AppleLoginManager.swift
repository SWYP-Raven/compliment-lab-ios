//
//  AppleLoginManager.swift
//  ComplimentLab
//
//  Created by CatSlave on 8/20/25.
//

import Foundation
import AuthenticationServices

class AppleLoginManager: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    @Published var token: String?
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first { $0.isKeyWindow }!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
           let identityToken = credential.identityToken,
           let identifyTokenString = String(data: identityToken, encoding: .utf8) {
            token = identifyTokenString
        }
    }
}
