//
//  CalendarHeaderView.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/17/25.
//

import SwiftUI

struct CalendarHeaderView: View {
    @ObservedObject var calendarViewModel: CalendarViewModel

    var body: some View {
        HStack {
            Button {
                calendarViewModel.shouldShowMonthPicker = true
            } label: {
                HStack(spacing: 2) {
                    Text(calendarViewModel.yearMonthDateFormatter(in: calendarViewModel.month))
                        .font(.suite(.bold, size: 17))
                        .foregroundStyle(Color.gray8)
                    
                    Image("Arrow down Default")
                        .frame(width: 20, height: 20)
                }
            }
            
            Spacer()
            
            Segmented(items: CalendarMode.allCases, selection: $calendarViewModel.mode)
                .onChange(of: calendarViewModel.mode) { _, newValue in
                    if newValue == .month {
                        calendarViewModel.getMonthDate()
                    } else {
                        calendarViewModel.getWeekDate()
                    }
                }
        }
    }
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


#Preview {
    CalendarHeaderView(calendarViewModel: CalendarViewModel())
}
