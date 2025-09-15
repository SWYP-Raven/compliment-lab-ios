//
//  WeekDateCellView.swift
//  ComplimentLab
//
//  Created by wayblemac02 on 9/15/25.
//

import SwiftUI

struct WeekDateCellView: View {
    @ObservedObject var toastManager: ToastManager
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
                    if let compliment = compliment {
                        if compliment.isRead {
                            Circle()
                                .fill(compliment.compliment.type.color2)
                                .overlay(compliment.compliment.type.stickerSImage)
                        } else {
                            Circle().fill(Color.gray3)
                        }
                    }
                case .today:
                    if let compliment = compliment {
                        if compliment.isRead {
                            Circle()
                                .fill(compliment.compliment.type.color2)
                                .overlay(compliment.compliment.type.stickerSImage)
                        } else {
                            Circle()
                                .fill(Color.blue1)
                                .overlay(
                                    Image("Plus Default")
                                        .renderingMode(.template)
                                        .foregroundColor(Color.blue4)
                                )
                        }
                    }
                case .future:
                    Circle().fill(Color.gray1)
                }
            }
        }
    }
}

