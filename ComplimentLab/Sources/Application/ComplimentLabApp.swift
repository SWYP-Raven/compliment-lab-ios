import SwiftUI

@main
struct ComplimentLabApp: App {
    @StateObject private var loginViewModel = LoginViewModel(useCase: LoginAPI())
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(loginViewModel)
        }
    }
}


