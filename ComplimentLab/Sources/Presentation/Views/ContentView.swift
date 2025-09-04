import SwiftUI

public struct ContentView: View {
    @State private var isActive = false
    
    public init() {}

    public var body: some View {
        PinkGradientSplashView(isActive: $isActive)
            .fullScreenCover(isPresented: $isActive) {
                if KeychainStorage.shared.hasToken() {
                    CustomTabView()
                } else {
                    LoginView(loginViewModel: LoginViewModel())
                }
            }
    }
}

struct PinkGradientSplashView: View {
    @Binding var isActive: Bool
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.pink3,
                    Color.pink2
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(.all)
            
            VStack {
                Spacer()
                
                Image("splash")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 295, height: 361)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeOut(duration: 0.5)) {
                isActive = true
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
