import ProjectDescription

let project = Project(
    name: "ComplimentLab",
    settings: .settings(
        base: [
            "CODE_SIGN_ENTITLEMENTS": "ComplimentLab/Config/ComplimentLab.entitlements"
        ],
    ),
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
                    "UIBackgroundModes": ["remote-notification"]
                ]
            ),
            sources: ["ComplimentLab/Sources/**"],
            resources: ["ComplimentLab/Resources/**"],
            entitlements: "Tuist/ComplimentLab.entitlements",
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
