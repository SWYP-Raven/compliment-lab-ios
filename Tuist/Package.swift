// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,]
        productTypes: [
            "RxSwift": .framework,
            "RxCocoa": .framework,
            "RxRelay": .framework,
            "Firebase": .framework,
            // GoogleMobileAds 는 정적 xcframework 라 .framework 로 강제하면 심볼이 날아간다
            "Lottie": .framework
        ]
    )
#endif

let package = Package(
    name: "ComplimentLab",
    dependencies: [
        // Add your own dependencies here:
        // .package(url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
        // You can read more about dependencies here: https://docs.tuist.io/documentation/tuist/dependencies
        .package(url: "https://github.com/ReactiveX/RxSwift", from: "6.9.0"),
        // 12.19.3 = eMudhra 중간 CA 유출 대응 패치
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "12.19.3"),
        .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.5.2"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS", from: "8.0.0"),
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads", from: "11.0.0")
    ]
)
