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
            destinations: [.iPhone],
            product: .app,
            bundleId: "com.raven.complimentlab",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
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
                    "UIUserInterfaceStyle": "Light",
                    "CFBundleShortVersionString": "$(MARKETING_VERSION)",
                    "CFBundleVersion": "$(CURRENT_PROJECT_VERSION)",
                    "CFBundleDisplayName": "칭찬연구소",
                    "BaseURL": "$(BASE_URL)",
                    "GADApplicationIdentifier": "$(GAD_APPLICATION_IDENTIFIER)",
                    "NSUserTrackingUsageDescription": "맞춤형 광고를 제공하고, 부적절한 광고를 차단하는 데 사용됩니다.",
                    "SKAdNetworkItems": [
                        ["SKAdNetworkIdentifier": "cstr6suwn9.skadnetwork"],
                        ["SKAdNetworkIdentifier": "4fzdc2evr5.skadnetwork"],
                        ["SKAdNetworkIdentifier": "2fnua5tdw4.skadnetwork"],
                        ["SKAdNetworkIdentifier": "ydx93a7ass.skadnetwork"],
                        ["SKAdNetworkIdentifier": "p78axxw29g.skadnetwork"],
                        ["SKAdNetworkIdentifier": "v72qych5uu.skadnetwork"],
                        ["SKAdNetworkIdentifier": "ludvb6z3bs.skadnetwork"],
                        ["SKAdNetworkIdentifier": "cp8zw746q7.skadnetwork"],
                        ["SKAdNetworkIdentifier": "3sh42y64q3.skadnetwork"],
                        ["SKAdNetworkIdentifier": "c6k4g5qg8m.skadnetwork"],
                        ["SKAdNetworkIdentifier": "s39g8k73mm.skadnetwork"],
                        ["SKAdNetworkIdentifier": "wg4vff78zm.skadnetwork"],
                        ["SKAdNetworkIdentifier": "3qy4746246.skadnetwork"],
                        ["SKAdNetworkIdentifier": "f38h382jlk.skadnetwork"],
                        ["SKAdNetworkIdentifier": "hs6bdukanm.skadnetwork"],
                        ["SKAdNetworkIdentifier": "mlmmfzh3r3.skadnetwork"],
                        ["SKAdNetworkIdentifier": "v4nxqhlyqp.skadnetwork"],
                        ["SKAdNetworkIdentifier": "wzmmz9fp6w.skadnetwork"],
                        ["SKAdNetworkIdentifier": "su67r6k2v3.skadnetwork"],
                        ["SKAdNetworkIdentifier": "yclnxrl5pm.skadnetwork"],
                        ["SKAdNetworkIdentifier": "t38b2kh725.skadnetwork"],
                        ["SKAdNetworkIdentifier": "7ug5zh24hu.skadnetwork"],
                        ["SKAdNetworkIdentifier": "gta9lk7p23.skadnetwork"],
                        ["SKAdNetworkIdentifier": "vutu7akeur.skadnetwork"],
                        ["SKAdNetworkIdentifier": "y5ghdn5j9k.skadnetwork"],
                        ["SKAdNetworkIdentifier": "v9wttpbfk9.skadnetwork"],
                        ["SKAdNetworkIdentifier": "n38lu8286q.skadnetwork"],
                        ["SKAdNetworkIdentifier": "47vhws6wlr.skadnetwork"],
                        ["SKAdNetworkIdentifier": "kbd757ywx3.skadnetwork"],
                        ["SKAdNetworkIdentifier": "9t245vhmpl.skadnetwork"],
                        ["SKAdNetworkIdentifier": "a2p9lx4jpn.skadnetwork"],
                        ["SKAdNetworkIdentifier": "22mmun2rn5.skadnetwork"],
                        ["SKAdNetworkIdentifier": "44jx6755aq.skadnetwork"],
                        ["SKAdNetworkIdentifier": "k674qkevps.skadnetwork"],
                        ["SKAdNetworkIdentifier": "4468km3ulz.skadnetwork"],
                        ["SKAdNetworkIdentifier": "2u9pt9hc89.skadnetwork"],
                        ["SKAdNetworkIdentifier": "8s468mfl3y.skadnetwork"],
                        ["SKAdNetworkIdentifier": "klf5c3l5u5.skadnetwork"],
                        ["SKAdNetworkIdentifier": "ppxm28t8ap.skadnetwork"],
                        ["SKAdNetworkIdentifier": "kbmxgpxpgc.skadnetwork"],
                        ["SKAdNetworkIdentifier": "uw77j35x4d.skadnetwork"],
                        ["SKAdNetworkIdentifier": "578prtvx9j.skadnetwork"],
                        ["SKAdNetworkIdentifier": "4dzt52r2t5.skadnetwork"],
                        ["SKAdNetworkIdentifier": "tl55sbb4fm.skadnetwork"],
                        ["SKAdNetworkIdentifier": "c3frkrj4fj.skadnetwork"],
                        ["SKAdNetworkIdentifier": "e5fvkxwrpn.skadnetwork"],
                        ["SKAdNetworkIdentifier": "8c4e2ghe7u.skadnetwork"],
                        ["SKAdNetworkIdentifier": "3rd42ekr43.skadnetwork"],
                        ["SKAdNetworkIdentifier": "97r2b46745.skadnetwork"],
                        ["SKAdNetworkIdentifier": "3qcr597p9d.skadnetwork"],
                    ],
                ]
            ),
            sources: ["ComplimentLab/Sources/**"],
            resources: ["ComplimentLab/Resources/**"],
            entitlements: "Tuist/ComplimentLab.entitlements",
            dependencies: [
                .external(name: "RxSwift"),
                .external(name: "RxCocoa"),
                .external(name: "RxRelay"),
                .external(name: "FirebaseAuth"),
                .external(name: "FirebaseCore"),
                .external(name: "FirebaseFirestore"),
                .external(name: "FirebaseMessaging"),
                .external(name: "GoogleSignIn"),
                .external(name: "GoogleMobileAds"),
                .external(name: "Lottie")
            ],
            settings: .settings(
                base: [
                    "MARKETING_VERSION": "1.0.2",
                    "CURRENT_PROJECT_VERSION": "2",
                    "OTHER_LDFLAGS": "$(inherited) -ObjC"
                ]
            )
        ),
        .target(
            name: "ComplimentLabTests",
            destinations: [.iPhone],
            product: .unitTests,
            bundleId: "dev.tuist.ComplimentLabTests",
            infoPlist: .default,
            sources: ["ComplimentLab/Tests/**"],
            resources: [],
            dependencies: [.target(name: "ComplimentLab")],
            settings: .settings(
                base: ["OTHER_LDFLAGS": "$(inherited) -ObjC"]
            )
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
