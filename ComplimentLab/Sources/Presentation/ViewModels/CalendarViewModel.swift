//
//  CalendarViewModel.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/17/25.
//

import Foundation

@MainActor
final class CalendarViewModel: ObservableObject {
    let calendar = Calendar.current
    @Published var selectDate: Date = Date()
    @Published var monthDates: [CalendarDate] = []
    @Published var weekDates: [CalendarDate] = [] // 선택한 주에 들어있는 날짜들
    @Published var month: Date = Date() {
        didSet {
            getMonthDate()
        }
    }
    @Published var week: Date = Date() {
        didSet {
            getWeekDate()
        }
    } // 선택한 주
    
    // 해당 월이 며칠까지 있는지 (ex: 28, 29, 30, 31)
    func numberOfDays(in date: Date) -> Int {
        return calendar.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    // 선택된 월에 표시할 날짜 목록
    // (이전 달 말 일부 + 이번 달 전체 + 다음 달 초 일부 포함)
    func getMonthDate() {
        let components = calendar.dateComponents([.year, .month], from: month)
        let firstDate = calendar.date(from: components)!
        let daysInMonth: Int = numberOfDays(in: month)
        let startDayOfMonth = calendar.component(.weekday, from: firstDate) - 1
        
        let numberOfRows = (startDayOfMonth + daysInMonth + 6) / 7
        let visibleDaysOfNextMonth = numberOfRows * 7 - (daysInMonth + startDayOfMonth)
        
        let startOffset = -startDayOfMonth
        let endOffset = (daysInMonth - 1) + visibleDaysOfNextMonth
        
        monthDates = (startOffset...endOffset).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: firstDate) else { return nil }
            let day = calendar.component(.day, from: date)
            return CalendarDate(day: day, date: date)
        }
    }
    
    // 선택된 주에 포함되는 날짜 목록
    func getWeekDate() {
        let today = calendar.startOfDay(for: week)
        let todayDay = calendar.component(.weekday, from: today) - 1
        
        let sunday = calendar.date(byAdding: .day, value: -(todayDay), to: today)!
        
        weekDates = (0..<7).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: sunday) else { return nil }
            let day = calendar.component(.day, from: date)
            return CalendarDate(day: day, date: date)
        }
    }
    
    // 캘린더 헤더 년월 포멧
    func yearMonthDateFormatter(in date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MMMM"
        formatter.locale = Locale(identifier: "ko_KR")
        
        return formatter.string(from: date)
    }
}
