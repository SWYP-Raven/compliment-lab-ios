//
//  CalendarView.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/17/25.
//

import SwiftUI

struct CalendarView: View {
    @StateObject private var toastManager = ToastManager()
    @ObservedObject var calendarViewModel: CalendarViewModel
    @ObservedObject var complimentViewModel: ComplimentViewModel
    
    @State var offset: CGSize = CGSize()
    @State private var page = 1
    @Binding var selection: Int
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading) {
                CalendarHeaderView(calendarViewModel: calendarViewModel, complimentViewModel: complimentViewModel)
                    .padding(.bottom, 15)
                NavigateToFriendView()
                    .padding(.bottom, 18)
                    .onTapGesture {
                        selection = 1
                    }
                WeekdayHeaderView()
                
                if calendarViewModel.mode == .month {
                    TabView(selection: $page) {
                        CalendarGridView(toastManager: toastManager, calendarViewModel: calendarViewModel, complimentViewModel: complimentViewModel, dates: calendarViewModel.prevMonthDates)
                            .tag(0)
                        
                        CalendarGridView(toastManager: toastManager, calendarViewModel: calendarViewModel, complimentViewModel: complimentViewModel, dates: calendarViewModel.monthDates)
                            .tag(1)
                        
                        CalendarGridView(toastManager: toastManager, calendarViewModel: calendarViewModel, complimentViewModel: complimentViewModel, dates: calendarViewModel.nextMonthDates)
                            .tag(2)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .onChange(of: page) { _, new in
                        switch new {
                        case 0:
                            // 왼쪽으로 스와이프하여 '이전 달' 페이지에 도달
                            let minDate = Calendar.current.date(from: DateComponents(year: 2025, month: 9, day: 1))!
                            
                            if let newMonth = Calendar.current.date(byAdding: .month, value: -1, to: calendarViewModel.month), newMonth >= minDate {
                                calendarViewModel.changeMonth(by: -1)
                                complimentViewModel.fetchMonthlyCompliment(year: calendarViewModel.selectedYear, month: calendarViewModel.selectedMonth)
                            } else {
                                toastManager.show(message: "이전의 칭찬은 준비되어 있지 않아요")
                            }
                            page = 1
                        case 2:
                            // 오른쪽으로 스와이프하여 '다음 달' 페이지에 도달
                            calendarViewModel.changeMonth(by: 1)
                            complimentViewModel.fetchMonthlyCompliment(year: calendarViewModel.selectedYear, month: calendarViewModel.selectedMonth)
                            page = 1
                        default:
                            break
                        }
                    }
                } else {
                    TabView(selection: $page) {
                        CalendarGridView(toastManager: toastManager, calendarViewModel: calendarViewModel, complimentViewModel: complimentViewModel, dates: calendarViewModel.prevWeekDates)
                            .tag(0)
                        
                        CalendarGridView(toastManager: toastManager, calendarViewModel: calendarViewModel, complimentViewModel: complimentViewModel, dates: calendarViewModel.weekDates)
                            .tag(1)
                        
                        CalendarGridView(toastManager: toastManager, calendarViewModel: calendarViewModel, complimentViewModel: complimentViewModel, dates: calendarViewModel.nextWeekDates)
                            .tag(2)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .onChange(of: page) { _, new in
                        switch new {
                        case 0:
                            let minDate = Calendar.current.date(from: DateComponents(year: 2025, month: 9, day: 1))!
                            
                            if let newWeek = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: calendarViewModel.week) {
                                if newWeek >= minDate {
                                    calendarViewModel.changeWeek(by: -1)
                                    complimentViewModel.fetchWeeklyCompliment(weekDates: calendarViewModel.weekDates)
                                } else {
                                    toastManager.show(message: "이전의 칭찬은 준비되어 있지 않아요")
                                }
                            }
                            page = 1
                            
                        case 2:
                            calendarViewModel.changeWeek(by: 1)
                            complimentViewModel.fetchWeeklyCompliment(weekDates: calendarViewModel.weekDates)
                            page = 1
                            
                        default:
                            break
                        }
                    }
                }
            }
            
            if toastManager.isShowing {
                ToastView(message: toastManager.message, imageTitle: "Check Toast")
            }
        }
        .padding(.horizontal, 20)
        .customNavigationBar(
            rightView: {
                HStack(spacing: 21) {
                    NavigationLink {
                        AlarmView()
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
        .task {
            if calendarViewModel.mode == .month {
                calendarViewModel.monthDates = calendarViewModel.getMonthDate(for: calendarViewModel.month)
                complimentViewModel.fetchMonthlyCompliment(year: calendarViewModel.selectedYear, month: calendarViewModel.selectedMonth)
            } else {
                calendarViewModel.weekDates = calendarViewModel.getWeekDate(for: calendarViewModel.week)
                complimentViewModel.fetchWeeklyCompliment(weekDates: calendarViewModel.weekDates)
            }
        }
    }
}
