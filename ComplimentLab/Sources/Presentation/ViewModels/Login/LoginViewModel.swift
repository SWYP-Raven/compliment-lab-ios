//
//  LoginViewModel.swift
//  ComplimentLab
//
//  Created by CatSlave on 8/8/25.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import GoogleSignIn

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var completed: Void?
    @Published var naviToProfileEdit = false
    @Published var isLoggedIn: Bool = false
    @Published var hasSeenOnboarding: Bool = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    @Published var username: String = ""

    private var authStateListener: AuthStateDidChangeListenerHandle?

    func setupAuthListener() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                guard let self else { return }
                guard let user else {
                    self.isLoggedIn = false
                    self.username = ""
                    return
                }
                let displayName = user.displayName ?? ""
                if !displayName.isEmpty {
                    self.username = displayName
                    self.isLoggedIn = true
                }
            }
        }
    }

    // MARK: - Apple Login

    func loginWithApple(credential: OAuthCredential) {
        Auth.auth().signIn(with: credential) { [weak self] result, error in
            guard let self, let user = result?.user, error == nil else { return }
            self.handleSignedInUser(user)
        }
    }

    // MARK: - Google Login

    func loginWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID,
              let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else { return }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { [weak self] result, error in
            guard let self, let user = result?.user, error == nil,
                  let idToken = user.idToken?.tokenString else { return }

            let firebaseCredential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )

            Auth.auth().signIn(with: firebaseCredential) { [weak self] result, error in
                guard let self, let firebaseUser = result?.user, error == nil else { return }
                self.handleSignedInUser(firebaseUser)
            }
        }
    }

    // MARK: - Profile Setup

    func requestSetProfile(name: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges { [weak self] error in
            DispatchQueue.main.async {
                guard error == nil else { return }
                self?.username = name
                self?.isLoggedIn = true
                self?.completed = ()
            }
        }
    }

    // MARK: - Account Management

    func editUser(nickname: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = nickname
        changeRequest?.commitChanges { [weak self] error in
            DispatchQueue.main.async {
                guard error == nil else { return }
                self?.username = nickname
            }
        }
    }

    func logout() {
        try? Auth.auth().signOut()
    }

    func reauthAndDelete(credential: OAuthCredential) {
        guard let user = Auth.auth().currentUser else { return }
        user.reauthenticate(with: credential) { _, error in
            guard error == nil else { return }
            let userId = user.uid
            Task {
                await Self.deleteFirestoreRecords(userId: userId)
                user.delete { _ in }
            }
        }
    }

    private static func deleteFirestoreRecords(userId: String) async {
        let ref = Firestore.firestore()
            .collection("users").document(userId)
            .collection("records")
        guard let snapshot = try? await ref.getDocuments() else { return }
        let batch = Firestore.firestore().batch()
        snapshot.documents.forEach { batch.deleteDocument($0.reference) }
        try? await batch.commit()
    }

    func markOnboardingSeenIfNeeded() {
        if !hasSeenOnboarding {
            hasSeenOnboarding = true
            UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        }
    }

    // MARK: - Private

    private func handleSignedInUser(_ user: FirebaseAuth.User) {
        if user.displayName?.isEmpty ?? true {
            naviToProfileEdit = true
        } else {
            username = user.displayName!
            isLoggedIn = true
        }
    }
}
