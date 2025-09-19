//
//  DateState.swift
//  ComplimentLab
//
//  Created by 이인호 on 9/15/25.
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
