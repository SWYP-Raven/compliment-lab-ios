import SwiftUI
import FirebaseCore
import GoogleMobileAds
import AppTrackingTransparency

@main
struct ComplimentLabApp: App {
    @StateObject private var loginViewModel: LoginViewModel

    init() {
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        #if DEBUG
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["099e42c45c39250ef955ed251a90f6fc"]
        #endif
        _loginViewModel = StateObject(wrappedValue: LoginViewModel())
    }

var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(loginViewModel)
                .onAppear {
                    loginViewModel.setupAuthListener()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        ATTrackingManager.requestTrackingAuthorization { _ in }
                    }
                }
        }
    }
}
