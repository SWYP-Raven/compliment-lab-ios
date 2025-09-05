//
//  CalendarView.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/17/25.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var toastManager: ToastManager
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
                        CalendarGridView(calendarViewModel: calendarViewModel, complimentViewModel: complimentViewModel, dates: calendarViewModel.prevMonthDates)
                            .tag(0)
                        
                        CalendarGridView(calendarViewModel: calendarViewModel, complimentViewModel: complimentViewModel, dates: calendarViewModel.monthDates)
                            .tag(1)
                        
                        CalendarGridView(calendarViewModel: calendarViewModel, complimentViewModel: complimentViewModel, dates: calendarViewModel.nextMonthDates)
                            .tag(2)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .onChange(of: page) { _, new in
                        switch new {
                        case 0:
                            // 왼쪽으로 스와이프하여 '이전 달' 페이지에 도달
                            calendarViewModel.changeMonth(by: -1)
                            complimentViewModel.fetchMonthlyCompliment(year: calendarViewModel.selectedYear, month: calendarViewModel.selectedMonth)
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
                        CalendarGridView(calendarViewModel: calendarViewModel, complimentViewModel: complimentViewModel, dates: calendarViewModel.prevWeekDates)
                            .tag(0)
                        
                        CalendarGridView(calendarViewModel: calendarViewModel, complimentViewModel: complimentViewModel, dates: calendarViewModel.weekDates)
                            .tag(1)
                        
                        CalendarGridView(calendarViewModel: calendarViewModel, complimentViewModel: complimentViewModel, dates: calendarViewModel.nextWeekDates)
                            .tag(2)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .onChange(of: page) { _, new in
                        switch new {
                        case 0:
                            calendarViewModel.changeWeek(by: -1)
                            complimentViewModel.fetchWeeklyCompliment(weekDates: calendarViewModel.weekDates)
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
        .task {
            if calendarViewModel.mode == .month {
                calendarViewModel.monthDates = calendarViewModel.getMonthDate(for: calendarViewModel.month)
                complimentViewModel.fetchMonthlyCompliment(year: calendarViewModel.selectedYear, month: calendarViewModel.selectedMonth)
            } else {
                calendarViewModel.weekDates = calendarViewModel.getWeekDate(for: calendarViewModel.week)
                complimentViewModel.fetchWeeklyCompliment(weekDates: calendarViewModel.weekDates)
            }
//            
//            let vm = LoginViewModel()
//            vm.logout()
        }
    }
}

struct CalendarGridView: View {
    @ObservedObject var calendarViewModel: CalendarViewModel
    @ObservedObject var complimentViewModel: ComplimentViewModel
    
    let dates: [CalendarDate]
    
    var body: some View {
        VStack {
            if calendarViewModel.mode == .month {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                    ForEach(dates) { value in
                        let compliment = complimentViewModel.complimentList.first { calendarViewModel.isSameDay(date1: $0.date, date2: value.date )}
                        
                        DateCellView(calendarViewModel: calendarViewModel, complimentViewModel: complimentViewModel, calendarDate: value, compliment: compliment)
                    }
                }
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                    ForEach(dates) { value in
                        let compliment = complimentViewModel.complimentList.first { calendarViewModel.isSameDay(date1: $0.date, date2: value.date )}
                            
                        WeekDateCellView(calendarViewModel: calendarViewModel, complimentViewModel: complimentViewModel, calendarDate: value, compliment: compliment)
                    }
                }
                
                compliementPreview()
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    @ViewBuilder
    func compliementPreview() -> some View {
        if let dailyCompliment = complimentViewModel.dailyCompliment {
            VStack(alignment: .leading) {
                HStack {
                    Image("Character Pink Stiker L")
                    Spacer()
                    Button {
                        let changedArchived = !dailyCompliment.isArchived
                        complimentViewModel.toggleArchive()
                        complimentViewModel.patchCompliment(isArchived: changedArchived, isRead: dailyCompliment.isRead, date: dailyCompliment.date)
                    } label: {
                        ZStack {
                            Image("Flower Default Default")
                            
                            if dailyCompliment.isArchived {
                                Image("Flower Pressed")
                            }
                        }
                    }
                }
                Text(dailyCompliment.compliment.content)
            }
            .padding(.horizontal, 17)
            .padding(.vertical, 25)
            .background(Color.pink1)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .onTapGesture {
                calendarViewModel.isButtonTapped = true
            }
        }
    }
}

struct DateCellView: View {
    @EnvironmentObject var toastManager: ToastManager
    @ObservedObject var calendarViewModel: CalendarViewModel
    @ObservedObject var complimentViewModel: ComplimentViewModel
    var calendarDate: CalendarDate
    let compliment: DailyCompliment?
    
    private var dateState: DateState {
        calendarViewModel.state(for: calendarDate.date, in: calendarViewModel.month)
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
                if Calendar.current.isDate(calendarDate.date, equalTo: calendarViewModel.month, toGranularity: .month) {
                    if dateState == .future {
                        toastManager.show(message: "쉿, 미래의 하루는 아직 비밀이에요")
                    } else {
                        calendarViewModel.selectDate = calendarDate.date
                        complimentViewModel.dailyCompliment = compliment
                        calendarViewModel.isButtonTapped = true
                        
                        if compliment?.isRead == false {
                            complimentViewModel.patchCompliment(isArchived: compliment!.isArchived, isRead: true, date: calendarDate.date)
                            
                            complimentViewModel.dailyCompliment?.isRead = true
                        }
                    }
                } else {
                    if calendarDate.date < calendarViewModel.month {
                        calendarViewModel.changeMonth(by: -1)
                    } else if calendarDate.date > calendarViewModel.month {
                        calendarViewModel.changeMonth(by: 1)
                    }
                }
            } label: {
                switch dateState {
                case .past:
                    if compliment?.isRead == true {
                        Circle()
                            .fill(Color.pink2)
                            .overlay(
                                Image("Character Pink Stiker S")
                            )
                    } else {
                        Circle().fill(Color.gray3)
                    }
                case .today:
                    if compliment?.isRead == true {
                        Circle()
                            .fill(Color.pink2)
                            .overlay(
                                Image("Character Pink Stiker S")
                            )
                    } else {
                        Circle()
                            .fill(Color.blue1)
                            .overlay(
                                Image("Plus Default")
                                    .renderingMode(.template)
                                    .foregroundColor(Color.blue4)
                            )
                    }
                case .future:
                    Circle().fill(Color.gray1)
                case .outsideMonth:
                    Circle().fill(Color.gray1)
                }
            }
        }
    }
}

struct WeekDateCellView: View {
    @EnvironmentObject var toastManager: ToastManager
    @ObservedObject var calendarViewModel: CalendarViewModel
    @ObservedObject var complimentViewModel: ComplimentViewModel
    var calendarDate: CalendarDate
    let compliment: DailyCompliment?
    
    private var dateState: DateState {
        calendarViewModel.state(for: calendarDate.date, in: calendarViewModel.week)
    }
    
    var body: some View {
        let isSameDay = calendarViewModel.isSameDay(date1: calendarViewModel.selectDate, date2: calendarDate.date)
        
        VStack(spacing: 8) {
            // 날짜 텍스트 (버튼 아님)
            switch dateState {
            case .past, .outsideMonth:
                Text("\(calendarDate.day)")
                    .font(.suite(.medium, size: 12))
                    .foregroundStyle(isSameDay ? Color.gray0 : Color.gray6)
                    .padding(.horizontal, 8)
                    .background(isSameDay ? Color.blue4 : Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
            case .today:
                Text("\(calendarDate.day)")
                    .font(.suite(.medium, size: 12))
                    .foregroundStyle(isSameDay ? Color.gray0 : Color.gray6)
                    .padding(.horizontal, 8)
                    .background(isSameDay ? Color.blue4 : Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
            case .future:
                Text("\(calendarDate.day)")
                    .font(.suite(.medium, size: 12))
                    .foregroundStyle(Color.gray6)
            }
            
            // Circle만 버튼
            Button {
                if dateState == .future {
                    toastManager.show(message: "쉿, 미래의 하루는 아직 비밀이에요")
                } else if dateState == .today && compliment?.isRead == false { // && 아직 확인 안한상태면
                    complimentViewModel.dailyCompliment = compliment
                    calendarViewModel.isButtonTapped = true
                    calendarViewModel.selectDate = calendarDate.date
                    
                    if compliment?.isRead == false {
                        complimentViewModel.patchCompliment(isArchived: compliment!.isArchived, isRead: true, date: calendarDate.date)
                        
                        complimentViewModel.dailyCompliment?.isRead = true
                    }
                } else {
                    if isSameDay {
                        complimentViewModel.dailyCompliment = compliment
                        calendarViewModel.isButtonTapped = true
                        
                        if compliment?.isRead == false {
                            complimentViewModel.patchCompliment(isArchived: compliment!.isArchived, isRead: true, date: calendarDate.date)
                            
                            complimentViewModel.dailyCompliment?.isRead = true
                        }
                    } else {
                        let compliment = complimentViewModel.complimentList.first { calendarViewModel.isSameDay(date1: $0.date, date2: calendarDate.date )}
                        
//                        guard let compliment = DailyCompliment.mockComplimentsMap[calendarDate.date] else { return }
                        complimentViewModel.dailyCompliment = compliment
                        calendarViewModel.selectDate = calendarDate.date
                    }
                }
            } label: {
                switch dateState {
                case .past, .outsideMonth:
                    if compliment?.isRead == true {
                        Circle()
                            .fill(Color.pink2)
                            .overlay(
                                Image("Character Pink Stiker S")
                            )
                    } else {
                        Circle().fill(Color.gray3)
                    }
                case .today:
                    if compliment?.isRead == true {
                        Circle()
                            .fill(Color.pink2)
                            .overlay(
                                Image("Character Pink Stiker S")
                            )
                    } else {
                        Circle()
                            .fill(Color.blue1)
                            .overlay(
                                Image("Plus Default")
                                    .renderingMode(.template)
                                    .foregroundColor(Color.blue4)
                            )
                    }
                case .future:
                    Circle().fill(Color.gray1)
                }
            }
        }
    }
}
