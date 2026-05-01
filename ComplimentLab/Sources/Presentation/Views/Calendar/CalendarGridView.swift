//
//  CalendarGridView.swift
//  ComplimentLab
//
//  Created by 이인호 on 9/15/25.
//

import SwiftUI

struct CalendarGridView: View {
    @ObservedObject var toastManager: ToastManager
    @ObservedObject var calendarViewModel: CalendarViewModel
    @ObservedObject var complimentViewModel: ComplimentViewModel
    
    let dates: [CalendarDate]
    
    var body: some View {
        VStack {
            if calendarViewModel.mode == .month {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                    ForEach(dates) { value in
                        let compliment = complimentViewModel.complimentList.first { calendarViewModel.isSameDay(date1: $0.date, date2: value.date )}
                        
                        MonthDateCellView(toastManager: toastManager, calendarViewModel: calendarViewModel, complimentViewModel: complimentViewModel, calendarDate: value, compliment: compliment)
                    }
                }
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                    ForEach(dates) { value in
                        let compliment = complimentViewModel.complimentList.first { calendarViewModel.isSameDay(date1: $0.date, date2: value.date )}
                            
                        WeekDateCellView(toastManager: toastManager, calendarViewModel: calendarViewModel, complimentViewModel: complimentViewModel, calendarDate: value, compliment: compliment)
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
            VStack(alignment: .leading, spacing: 22) {
                HStack {
                    dailyCompliment.compliment.type.stickerSImage
                        .frame(width: 40, height: 40)
                        .background(
                            Circle().fill(dailyCompliment.compliment.type.color2)
                        )
                    Spacer()
                    Button {
                        let changedArchived = !dailyCompliment.isArchived
                        complimentViewModel.patchCompliment(isArchived: changedArchived, isRead: dailyCompliment.isRead, date: dailyCompliment.date)
                        
                        // 주간 배열에서도 아카이브 정보를 바꿔줘야함
                        if let index = complimentViewModel.complimentList.firstIndex(where: { calendarViewModel.isSameDay(date1: $0.date, date2: dailyCompliment.date)}) {
                            complimentViewModel.complimentList[index].isArchived = changedArchived
                        }
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
                    .font(.suite(.medium, size: 14))
            }
            .padding(.horizontal, 17)
            .padding(.vertical, 25)
            .background(dailyCompliment.compliment.type.color1)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .onTapGesture {
                calendarViewModel.isButtonTapped = true
            }
        }
    }
}
