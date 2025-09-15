import ProjectDescription

let project = Project(
    name: "ComplimentLab",
    options: .options(
        defaultKnownRegions: ["en", "ko"],
        developmentRegion: "ko"
    ),
    settings: .settings(
        base: [
            "CODE_SIGN_ENTITLEMENTS": "ComplimentLab/Config/ComplimentLab.entitlements"
        ],
        configurations: [
            .debug(
                name: "Debug",
                xcconfig: .relativeToRoot("XCConfig/dev.xcconfig")
            ),
            .release(
                name: "Release",
                xcconfig: .relativeToRoot("XCConfig/prod.xcconfig")
            ),
        ]
    ),
    targets: [
        .target(
            name: "ComplimentLab",
            destinations: .iOS,
            product: .app,
            bundleId: "com.raven.complimentlab",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "pink3",
                        "UIImageName": "splash",
                    ],
                    "UIBackgroundModes": ["remote-notification"],
                    "UIAppFonts": [
                        "SUITE-Bold.otf",
                        "SUITE-ExtraBold.otf",
                        "SUITE-Heavy.otf",
                        "SUITE-Light.otf",
                        "SUITE-Medium.otf",
                        "SUITE-Regular.otf",
                        "SUITE-SemiBold.otf",
                    ],
                    "CFBundleDisplayName": "칭찬연구소",
                    "BaseURL": "$(BASE_URL)"
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
    ],
    schemes: [
        .scheme(
            name: "ComplimentLab-Dev",
            buildAction: .buildAction(targets: [
                .target("ComplimentLab")
            ]),
            runAction: .runAction(configuration: .debug),
            archiveAction: .archiveAction(configuration: .debug),
            profileAction: .profileAction(configuration: .debug),
            analyzeAction: .analyzeAction(configuration: .debug)
        ),
        .scheme(
            name: "ComplimentLab-Prod",
            buildAction: .buildAction(targets: [
                .target("ComplimentLab")
            ]),
            runAction: .runAction(configuration: .release),
            archiveAction: .archiveAction(configuration: .release),
            profileAction: .profileAction(configuration: .release),
            analyzeAction: .analyzeAction(configuration: .release)
        )
    ]
)
