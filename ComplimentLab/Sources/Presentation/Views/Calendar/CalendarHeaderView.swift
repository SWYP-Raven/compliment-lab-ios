//
//  CalendarHeaderView.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/17/25.
//

import SwiftUI
import GoogleMobileAds

struct CalendarHeaderView: View {
    @ObservedObject var calendarViewModel: CalendarViewModel
    @ObservedObject var complimentViewModel: ComplimentViewModel

    var body: some View {
        HStack {
            Button {
                calendarViewModel.shouldShowMonthPicker = true
            } label: {
                HStack(spacing: 2) {
                    Text(DateFormatterManager.shared.yearMonth(from: calendarViewModel.month))
                        .font(.suite(.bold, size: 17))
                        .foregroundStyle(Color.gray8)
                    
                    Image("Arrow down Default")
                        .frame(width: 20, height: 20)
                }
            }
            
            Spacer()
            
            CustomSegmentedControl(items: CalendarMode.allCases, cornerRadius: 13.5, selection: $calendarViewModel.mode)
                .frame(width: 85, height: 26)
                .onChange(of: calendarViewModel.mode) { _, newValue in
                    if newValue == .month {
                        calendarViewModel.monthDates = calendarViewModel.getMonthDate(for: calendarViewModel.month)
                        complimentViewModel.fetchMonthlyCompliment(year: calendarViewModel.selectedYear, month: calendarViewModel.selectedMonth)
                    } else {
                        calendarViewModel.weekDates = calendarViewModel.getWeekDate(for: calendarViewModel.week)
                        complimentViewModel.fetchWeeklyCompliment(weekDates: calendarViewModel.weekDates)
                    }
                }
        }
    }
}

struct BannerAdView: UIViewRepresentable {
    private let adUnitID = "ca-app-pub-8889421922972515/2380263700"
//    private let adUnitID = "ca-app-pub-3940256099942544/2934735716" // 테스트

    private static var adSize: GADAdSize {
        UIScreen.main.bounds.width <= 375 ? GADAdSizeBanner : GADAdSizeLargeBanner
    }

    static var height: CGFloat {
        adSize.size.height
    }

    func makeUIView(context: Context) -> GADBannerView {
        let bannerView = GADBannerView()
        bannerView.adUnitID = adUnitID
        bannerView.backgroundColor = .clear
        bannerView.adSize = BannerAdView.adSize

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController
        else { return bannerView }

        bannerView.rootViewController = rootVC
        bannerView.load(GADRequest())
        return bannerView
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) {}
}

struct WeekdayHeaderView: View {
    let weekdaySymbols = Calendar.current.veryShortWeekdaySymbols
    
    var body: some View {
        HStack {
            ForEach(Array(weekdaySymbols.enumerated()), id: \.offset) { _, symbol in
                Text(symbol)
                    .frame(maxWidth: .infinity)
                    .font(.suite(.medium, size: 12))
                    .foregroundStyle(Color.gray4)
            }
        }
        .padding(.bottom)
    }
}
