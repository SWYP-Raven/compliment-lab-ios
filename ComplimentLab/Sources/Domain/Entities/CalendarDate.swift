//
//  CalendarDate.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/17/25.
//

import Foundation

struct CalendarDate: Identifiable {
    let id = UUID().uuidString
    let day: Int
    let date: Date
}
