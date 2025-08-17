//
//  CalendarView.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/17/25.
//

import SwiftUI

struct CalendarView: View {
    @StateObject var calendarViewModel = CalendarViewModel()
    @State var offset: CGSize = CGSize()
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                CalendarHeaderView(calendarViewModel: calendarViewModel)
                    .padding(.bottom, 10)
                NavigateToFriendView()
                    .padding(.bottom, 8)
                WeekdayHeaderView()
                
                if calendarViewModel.mode == .month {
                    CalendarGridView(calendarViewModel: calendarViewModel, dates: calendarViewModel.monthDates)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                if abs(gesture.translation.width) > 10 { // 일정 수준 이상 드래그 되었을 때만 처리
                                    calendarViewModel.isDragging = true
                                }
                                self.offset = gesture.translation
                            }
                            .onEnded { gesture in
                                if gesture.translation.width < -100 {
                                    calendarViewModel.changeMonth(by: 1)
                                } else if gesture.translation.width > 100 {
                                    calendarViewModel.changeMonth(by: -1)
                                }
                                self.offset = CGSize()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    self.calendarViewModel.isDragging = false
                                }
                            }
                    )
                } else {
                    CalendarGridView(calendarViewModel: calendarViewModel, dates: calendarViewModel.weekDates)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                if abs(gesture.translation.width) > 10 { // 일정 수준 이상 드래그 되었을 때만 처리
                                    calendarViewModel.isDragging = true
                                }
                                self.offset = gesture.translation
                            }
                            .onEnded { gesture in
                                if gesture.translation.width < -100 {
                                    calendarViewModel.changeWeek(by: 1)
                                } else if gesture.translation.width > 100 {
                                    calendarViewModel.changeWeek(by: -1)
                                }
                                self.offset = CGSize()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    self.calendarViewModel.isDragging = false
                                }
                            }
                    )
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            
            if calendarViewModel.shouldShowMonthPicker {
                Color.black
                    .opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        calendarViewModel.shouldShowMonthPicker = false
                    }
                
                YearMonthPickerView(calendarViewModel: calendarViewModel, pickerYear: calendarViewModel.selectedYear)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(35)
            }
        }
    }
}

struct CalendarGridView: View {
    @ObservedObject var calendarViewModel: CalendarViewModel
    let dates: [CalendarDate]
    
    var body: some View {
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                ForEach(dates) { value in
                    DateCellView(calendarViewModel: calendarViewModel, calendarDate: value)
                }
            }
        }
        .task {
            if calendarViewModel.mode == .month {
                calendarViewModel.getMonthDate()
            } else {
                calendarViewModel.getWeekDate()
            }
        }
    }
}

struct DateCellView: View {
    @ObservedObject var calendarViewModel: CalendarViewModel
    var calendarDate: CalendarDate
    
    private var dateState: DateState {
        calendarViewModel.state(for: calendarDate.date, in: calendarViewModel.week)
    }
    
    var body: some View {
        VStack {
            Button {
                if !calendarViewModel.isDragging {
                    if Calendar.current.isDate(calendarDate.date, equalTo: calendarViewModel.month, toGranularity: .month) {
                        calendarViewModel.selectDate = calendarDate.date
                    } else {
                        if calendarDate.date < calendarViewModel.month {
                            calendarViewModel.changeMonth(by: -1)
                        } else if calendarDate.date > calendarViewModel.month {
                            calendarViewModel.changeMonth(by: 1)
                        }
                    }
                }
            } label: {
                VStack {
                    switch dateState {
                    case .past:
                        Text("\(calendarDate.day)")
                            .font(.suite(.medium, size: 12))
                            .foregroundStyle(Color.gray6)
                        
                        Circle()
                            .fill(Color.gray3)
                    case .today:
                        Text("\(calendarDate.day)")
                            .font(.suite(.medium, size: 12))
                            .foregroundStyle(Color.gray0)
                            .padding(.horizontal, 8)
                            .background(Color.blue4)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        Circle()
                            .fill(Color.blue1)
                            .overlay(
                                Image("Plus Default")
                                    .renderingMode(.template)
                                    .foregroundColor(Color.blue4)
                            )
                        
                    case .future:
                        Text("\(calendarDate.day)")
                            .font(.suite(.medium, size: 12))
                            .foregroundStyle(Color.gray6)
                        
                        Circle()
                            .fill(Color.gray1)
                    case .outsideMonth:
                        Text("\(calendarDate.day)")
                            .font(.suite(.medium, size: 12))
                            .foregroundStyle(Color.gray2)
                        
                        Circle()
                            .fill(Color.gray1)
                    }
                }
            }
        }
    }
}

#Preview {
    CalendarView()
}
