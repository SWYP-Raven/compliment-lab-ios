//
//  InterstitialAdManager.swift
//  ComplimentLab
//

import UIKit
import GoogleMobileAds

final class InterstitialAdManager: NSObject, ObservableObject {
    private var interstitial: GADInterstitialAd?
    private var onDismissed: (() -> Void)?

    override init() { super.init() }

    func loadAd() {
        GADInterstitialAd.load(
            withAdUnitID: "ca-app-pub-8889421922972515/8929360180", // 테스트: "ca-app-pub-3940256099942544/4411468910"
            request: GADRequest()
        ) { [weak self] ad, error in
            guard let self else { return }
            if error != nil { return }
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
        }
    }

    func showAd(onDismissed: @escaping () -> Void) {
        self.onDismissed = onDismissed
        guard let ad = interstitial,
              let rootVC = UIApplication.shared.connectedScenes
                  .compactMap({ $0 as? UIWindowScene })
                  .compactMap({ $0.windows.first { $0.isKeyWindow } })
                  .first?.rootViewController
        else {
            onDismissed()
            return
        }
        ad.present(fromRootViewController: rootVC)
    }
}

extension InterstitialAdManager: GADFullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        onDismissed?()
        loadAd()
    }

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        onDismissed?()
    }
}
