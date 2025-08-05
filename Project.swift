import ProjectDescription

let project = Project(
    name: "ComplimentLab",
    targets: [
        .target(
            name: "ComplimentLab",
            destinations: .iOS,
            product: .app,
            bundleId: "com.raven.complimentlab",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["ComplimentLab/Sources/**"],
            resources: ["ComplimentLab/Resources/**"],
            dependencies: [
                .external(name: "RxSwift"),
                .external(name: "RxCocoa"),
                .external(name: "RxRelay"),
                .external(name: "FirebaseMessaging")
            ]
        ),
        .target(
            name: "ComplimentLabTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "dev.tuist.ComplimentLabTests",
            infoPlist: .default,
            sources: ["ComplimentLab/Tests/**"],
            resources: [],
            dependencies: [.target(name: "ComplimentLab")]
        ),
    ]
)
