//
//  MonthDateCellView.swift
//  ComplimentLab
//
//  Created by wayblemac02 on 9/15/25.
//

import SwiftUI

struct MonthDateCellView: View {
    @ObservedObject var toastManager: ToastManager
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
                case .outsideMonth:
                    Circle().fill(Color.gray1)
                }
            }
        }
    }
}
