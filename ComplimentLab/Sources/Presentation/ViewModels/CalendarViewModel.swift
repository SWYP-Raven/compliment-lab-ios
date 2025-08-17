//
//  CalendarViewModel.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/17/25.
//

import Foundation

/// - past: 오늘 이전 날짜
/// - today: 오늘 날짜
/// - future: 오늘 이후 날짜
/// - outsideMonth: 해당 월에 속하지 않음
enum DateState {
    case past
    case today
    case future
    case outsideMonth
}

@MainActor
final class CalendarViewModel: ObservableObject {
    let calendar = Calendar.current
    @Published var selectDate: Date = Date()
    @Published var monthDates: [CalendarDate] = []
    @Published var weekDates: [CalendarDate] = [] // 선택한 주에 들어있는 날짜들
    @Published var selectedYear: Int = Calendar.current.component(.year, from: .now)
    @Published var selectedMonth: Int = Calendar.current.component(.month, from: .now)
    @Published var shouldShowMonthPicker = false
    
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
    
    @Published var isDragging = false // 달력 스와이프 시 셀 눌림 방지
    
    // 해당 달이 며칠까지 있는지 (ex: 28, 29, 30, 31)
    func numberOfDays(in date: Date) -> Int {
        return calendar.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    // 선택된 달에 표시할 날짜 목록
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
    
    // 달 변경 (주간 달력 모드에서 달이 바뀌면 해당 달의 1일로 주를 초기화)
    func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: month) {
            self.month = newMonth
            
            var components = calendar.dateComponents([.year, .month], from: newMonth)
            components.day = 1
            
            if let firstWeekOfMonth = calendar.date(from: components) {
                self.week = firstWeekOfMonth
            }
        }
    }
    
    func changeMonth(year: Int, month: Int) {
        let components = DateComponents(year: year, month: month)
        if let newMonth = calendar.date(from: components) {
            self.month = newMonth
            self.selectedYear = year
            self.selectedMonth = month
            
            var components = calendar.dateComponents([.year, .month], from: newMonth)
            components.day = 1
            
            if let firstWeekOfMonth = calendar.date(from: components) {
                self.week = firstWeekOfMonth
            }
        }
    }
    
    // 주 변경 (다른 달로 넘어가면 해당 달로 월 갱신)
    func changeWeek(by value: Int) {
        if let newWeek = calendar.date(byAdding: .weekOfYear, value: value, to: week) {
            self.week = newWeek
            
            let newMonthComponent = calendar.dateComponents([.month], from: newWeek)
            let oldMonthComponent = calendar.dateComponents([.month], from: month)
            
            if newMonthComponent.month != oldMonthComponent.month {
                self.month = newWeek
            }
        }
    }
    
    // 날짜 상태 판별
    func state(for date: Date, in month: Date) -> DateState {
        let today = calendar.startOfDay(for: Date())
        
        guard calendar.isDate(date, equalTo: month, toGranularity: .month) else {
            return .outsideMonth
        }
        
        if calendar.isDateInToday(date) {
            return .today
        }
        
        return date < today ? .past : .future
    }
}
