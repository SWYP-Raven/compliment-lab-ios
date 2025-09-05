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

enum CalendarMode: String, CaseIterable, CustomStringConvertible {
    case week = "주간"
    case month = "월간"
    
    var description: String { rawValue }
}

@MainActor
final class CalendarViewModel: ObservableObject {
    let calendar = Calendar.current
    let today = Calendar.current.startOfDay(for: Date())
    @Published var selectDate: Date = Date()
    @Published var monthDates: [CalendarDate] = []
    @Published var weekDates: [CalendarDate] = [] // 선택한 주에 들어있는 날짜들
    @Published var selectedYear: Int = Calendar.current.component(.year, from: .now)
    @Published var selectedMonth: Int = Calendar.current.component(.month, from: .now)
    @Published var shouldShowMonthPicker = false
    
    @Published var month: Date = Date() {
        didSet {
            monthDates = getMonthDate(for: month)
            
            let prev = calendar.date(byAdding: .month, value: -1, to: month) ?? month
            let next = calendar.date(byAdding: .month, value:  1, to: month) ?? month
            prevMonthDates = getMonthDate(for: prev)
            nextMonthDates = getMonthDate(for: next)
        }
    }
    @Published var week: Date = Date() {
        didSet {
            weekDates = getWeekDate(for: week)
            
            let prev = calendar.date(byAdding: .weekOfYear, value: -1, to: week) ?? week
            let next = calendar.date(byAdding: .weekOfYear, value:  1, to: week) ?? week
            prevMonthDates = getWeekDate(for: prev)
            nextMonthDates = getWeekDate(for: next)
        }
    } // 선택한 주
    
    @Published var mode: CalendarMode = {
        if let saved = UserDefaults.standard.string(forKey: "mode"), let savedMode = CalendarMode(rawValue: saved) {
            return savedMode
        }
        return .month
    }() {
        didSet {
            UserDefaults.standard.set(mode.rawValue, forKey: "mode")
        }
    }
    
    @Published var isDragging = false // 달력 스와이프 시 셀 눌림 방지
    @Published var isButtonTapped = false
    
    // 이전 & 다음달 미리 그려둠
    var prevMonthDates: [CalendarDate] = []
    var nextMonthDates: [CalendarDate] = []
    
    // 이전 & 다음주 미리 그려둠
    var prevWeekDates: [CalendarDate] = []
    var nextWeekDates: [CalendarDate] = []

    
    // 해당 달이 며칠까지 있는지 (ex: 28, 29, 30, 31)
    func numberOfDays(in date: Date) -> Int {
        return calendar.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    // 선택된 달에 표시할 날짜 목록
    // (이전 달 말 일부 + 이번 달 전체 + 다음 달 초 일부 포함)
    func getMonthDate(for month: Date) -> [CalendarDate] {
        let components = calendar.dateComponents([.year, .month], from: month)
        let firstDate = calendar.date(from: components)!
        let daysInMonth: Int = numberOfDays(in: month)
        let startDayOfMonth = calendar.component(.weekday, from: firstDate) - 1
        
        let numberOfRows = (startDayOfMonth + daysInMonth + 6) / 7
        let visibleDaysOfNextMonth = numberOfRows * 7 - (daysInMonth + startDayOfMonth)
        
        let startOffset = -startDayOfMonth
        let endOffset = (daysInMonth - 1) + visibleDaysOfNextMonth
        
        return (startOffset...endOffset).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: firstDate) else { return nil }
            let day = calendar.component(.day, from: date)
            return CalendarDate(day: day, date: date)
        }
    }
    
    // 선택된 주에 포함되는 날짜 목록
    func getWeekDate(for week: Date) -> [CalendarDate] {
        let today = calendar.startOfDay(for: week)
        let todayDay = calendar.component(.weekday, from: today) - 1
        
        let sunday = calendar.date(byAdding: .day, value: -(todayDay), to: today)!
        
        return (0..<7).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: sunday) else { return nil }
            let day = calendar.component(.day, from: date)
            return CalendarDate(day: day, date: date)
        }
    }
    
    // 달 변경 (주간 달력 모드에서 달이 바뀌면 해당 달의 1일로 주를 초기화)
    func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: month) {
            self.month = newMonth
            
            var components = calendar.dateComponents([.year, .month], from: newMonth)
            
            if let y = components.year, let m = components.month {
                self.selectedYear = y
                self.selectedMonth = m
            }
            
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
            
            let newMonthComponent = calendar.dateComponents([.year, .month], from: newWeek)
            let oldMonthComponent = calendar.dateComponents([.year, .month], from: month)
            
            if newMonthComponent.month != oldMonthComponent.month {
                self.month = newWeek

                if let y = newMonthComponent.year, let m = newMonthComponent.month {
                    self.selectedYear = y
                    self.selectedMonth = m
                }
            }
        }
    }
    
    // 날짜 상태 판별
    func state(for date: Date, in month: Date) -> DateState {
        guard calendar.isDate(date, equalTo: month, toGranularity: .month) else {
            return .outsideMonth
        }
        
        if calendar.isDateInToday(date) {
            return .today
        }
        
        return date < today ? .past : .future
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}
