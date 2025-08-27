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
            
            CustomSegmentedControl(items: CalendarMode.allCases, selection: $calendarViewModel.mode)
                .onChange(of: calendarViewModel.mode) { _, newValue in
                    if newValue == .month {
                        calendarViewModel.monthDates = calendarViewModel.getMonthDate(for: calendarViewModel.month)
                    } else {
                        calendarViewModel.weekDates = calendarViewModel.getWeekDate(for: calendarViewModel.week)
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

// TODO: - 유저 닉네임 추가
struct NavigateToFriendView: View {
    var body: some View {
        HStack {
            Image("Character Pink half")
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("Username님,")
                    .font(.suite(.bold, size: 17))
                    .foregroundColor(Color.blue4)
                
                Text("나만의 칭구를 만나보세요!")
                    .font(.suite(.medium, size: 14))
                    .foregroundColor(Color.gray5)
            }
            
            Spacer()
            
            Image("Arrow right Default")
                .renderingMode(.template)
                .foregroundColor(Color.blue4)
        }
        .frame(maxWidth: .infinity)
        .padding(.leading, 22)
        .padding(.trailing, 15)
        .background(Color.blue1)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}


#Preview {
    CalendarHeaderView(calendarViewModel: CalendarViewModel())
}
