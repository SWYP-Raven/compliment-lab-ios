//
//  CalendarView.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/17/25.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var calendarViewModel: CalendarViewModel
    @State var offset: CGSize = CGSize()
    @State private var page = 1
    @Binding var selection: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            CalendarHeaderView(calendarViewModel: calendarViewModel)
                .padding(.bottom, 15)
            NavigateToFriendView()
                .padding(.bottom, 18)
                .onTapGesture {
                    selection = 1
                }
            WeekdayHeaderView()
            
            if calendarViewModel.mode == .month {
                TabView(selection: $page) {
                    CalendarGridView(calendarViewModel: calendarViewModel, dates: calendarViewModel.prevMonthDates)
                        .tag(0)
                    
                    CalendarGridView(calendarViewModel: calendarViewModel, dates: calendarViewModel.monthDates)
                        .tag(1)
                    
                    CalendarGridView(calendarViewModel: calendarViewModel, dates: calendarViewModel.nextMonthDates)
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .onChange(of: page) { _, new in
                    switch new {
                    case 0:
                        calendarViewModel.changeMonth(by: -1)
                        page = 1
                    case 2:
                        // 오른쪽으로 스와이프하여 '다음 달' 페이지에 도달
                        calendarViewModel.changeMonth(by: 1)
                        page = 1
                    default:
                        break
                    }
                }
            } else {
                TabView(selection: $page) {
                    CalendarGridView(calendarViewModel: calendarViewModel, dates: calendarViewModel.prevWeekDates)
                        .tag(0)
                    
                    CalendarGridView(calendarViewModel: calendarViewModel, dates: calendarViewModel.weekDates)
                        .tag(1)
                    
                    CalendarGridView(calendarViewModel: calendarViewModel, dates: calendarViewModel.nextWeekDates)
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .onChange(of: page) { _, new in
                    switch new {
                    case 0:
                        // 왼쪽으로 스와이프하여 '이전 달' 페이지에 도달
                        calendarViewModel.changeWeek(by: -1)
                        
                        // 페이지는 다시 가운데로 되돌려 무한 스와이프처럼 보이게
                        // 애니메이션 끄고 즉시 리셋(깜빡임 방지)
                        withAnimation(nil) { page = 1 }
                        
                    case 2:
                        // 오른쪽으로 스와이프하여 '다음 달' 페이지에 도달
                        calendarViewModel.changeWeek(by: 1)
                        withAnimation(nil) { page = 1 }
                        
                    default:
                        break
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .customNavigationBar(
            rightView: {
                HStack(spacing: 21) {
                    Button {
                        
                    } label: {
                        Image("Alarm Default")
                    }
                    
                    NavigationLink {
                        SettingView(showBackButton: true)
                    } label: {
                        Image("Setting Default")
                    }
                }
            }
        )
    }
}

struct CalendarGridView: View {
    @ObservedObject var calendarViewModel: CalendarViewModel
    let dates: [CalendarDate]
    
    var body: some View {
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 8) {
                ForEach(dates) { value in
                    DateCellView(calendarViewModel: calendarViewModel, calendarDate: value)
                }
            }
        }
        .task {
            if calendarViewModel.mode == .month {
                calendarViewModel.monthDates = calendarViewModel.getMonthDate(for: calendarViewModel.month)
            } else {
                calendarViewModel.weekDates = calendarViewModel.getWeekDate(for: calendarViewModel.week)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

struct DateCellView: View {
    @ObservedObject var calendarViewModel: CalendarViewModel
    var calendarDate: CalendarDate
    
    private var dateState: DateState {
        calendarViewModel.state(for: calendarDate.date, in: calendarViewModel.week)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            // 날짜 텍스트 (버튼 아님)
            switch dateState {
            case .past:
                Text("\(calendarDate.day)")
                    .font(.suite(.medium, size: 12))
                    .foregroundStyle(Color.gray6)

            case .today:
                Text("\(calendarDate.day)")
                    .font(.suite(.medium, size: 12))
                    .foregroundStyle(Color.gray0)
                    .padding(.horizontal, 8)
                    .background(Color.blue4)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

            case .future:
                Text("\(calendarDate.day)")
                    .font(.suite(.medium, size: 12))
                    .foregroundStyle(Color.gray6)

            case .outsideMonth:
                Text("\(calendarDate.day)")
                    .font(.suite(.medium, size: 12))
                    .foregroundStyle(Color.gray2)
            }

            // Circle만 버튼
            Button {
                if !calendarViewModel.isDragging {
                    if Calendar.current.isDate(calendarDate.date, equalTo: calendarViewModel.month, toGranularity: .month) {
                        calendarViewModel.selectDate = calendarDate.date
                        calendarViewModel.isButtonTapped = true
                    } else {
                        if calendarDate.date < calendarViewModel.month {
                            calendarViewModel.changeMonth(by: -1)
                        } else if calendarDate.date > calendarViewModel.month {
                            calendarViewModel.changeMonth(by: 1)
                        }
                    }
                }
            } label: {
                switch dateState {
                case .past:
                    Circle().fill(Color.gray3)
                case .today:
                    Circle()
                        .fill(Color.blue1)
                        .overlay(
                            Image("Plus Default")
                                .renderingMode(.template)
                                .foregroundColor(Color.blue4)
                        )
                case .future:
                    Circle().fill(Color.gray1)
                case .outsideMonth:
                    Circle().fill(Color.gray1)
                }
            }
        }
    }
}
