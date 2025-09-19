//
//  DateFormatterManager.swift
//  ComplimentLab
//
//  Created by 이인호 on 9/4/25.
//

import Foundation

final class DateFormatterManager {
    static let shared = DateFormatterManager()
    private init() {}
    
    private let yearMonthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MMMM"
        return formatter
    }()
    
    let apiFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private let dottedFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }()
    
    private let dayOfWeekFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "d EEEE"
        return formatter
    }()
    
    private let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년"
        return formatter
    }()
    
    private let monthEnglishFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MMMM"
        return formatter
    }()
    
    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }()
    
    func yearMonth(from date: Date) -> String { yearMonthFormatter.string(from: date) }
    func apiDate(from date: Date) -> String { apiFormatter.string(from: date) }
    func dayOfWeek(from date: Date) -> String { dayOfWeekFormatter.string(from: date) }
    func year(from date: Date) -> String { yearFormatter.string(from: date) }
    func monthEnglish(from date: Date) -> String { monthEnglishFormatter.string(from: date) }
    func day(from date: Date) -> String { dayFormatter.string(from: date) }
    func dottedDate(from date: Date) -> String { dottedFormatter.string(from: date) }
    
    func chatDisplayString(from date: Date) -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        
        if calendar.isDateInToday(date) {
            formatter.dateFormat = "a h:mm"
            return formatter.string(from: date)
        } else if calendar.isDateInYesterday(date) {
            return "어제"
        } else if let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: Date()),
                  calendar.isDate(date, inSameDayAs: twoDaysAgo) {
            return "그저께"
        } else {
            formatter.dateFormat = "M월 d일"
            return formatter.string(from: date)
        }
    }
}
