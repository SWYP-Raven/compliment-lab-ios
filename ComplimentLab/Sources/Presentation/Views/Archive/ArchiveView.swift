//
//  ArchiveView.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/27/25.
//

import SwiftUI

struct ArchiveView: View {
    @StateObject private var archiveViewModel = ArchiveViewModel()
    @ObservedObject var calendarViewModel: CalendarViewModel
    @ObservedObject var complimentViewModel: ComplimentViewModel
    @State var selectedPick = "일력"
    
    var body: some View {
        VStack {
            ArchiveHeaderView(calendarViewModel: calendarViewModel, selectedPick: $selectedPick)
            
            if selectedPick == "일력" {
                DailyCalendarArchive(archiveViewModel: archiveViewModel, calendarViewModel: calendarViewModel, complimentViewModel: complimentViewModel)
            } else {
                // 칭찬 아카이브
            }
        }
        .padding(.horizontal, 20)
        .customNavigationBar(
            rightView: {
                Menu {
                    Button { archiveViewModel.sortByDate(type: .recent) } label: { Text("최근순") }
                    Button { archiveViewModel.sortByDate(type: .past) } label: { Text("이전순") }
                } label: {
                    Image("list defalt")
                }
            }
        )
        .task {
            archiveViewModel.sortByDate(type: .recent)
        }
    }
}

struct DailyCalendarArchive: View {
    @ObservedObject var archiveViewModel: ArchiveViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    @ObservedObject var complimentViewModel: ComplimentViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(archiveViewModel.dailyCompliments, id: \.self) { dailyCompliment in
                    NavigationLink(destination: TodayComplimentView(calendarViewModel: calendarViewModel, complimentViewModel: complimentViewModel)) {
                        VStack(alignment: .leading, spacing: 22) {
                            HStack(alignment: .center) {
                                dailyCompliment.compliment.type.stickerSImage
                                    .frame(width: 40, height: 40)
                                    .background(
                                        Circle().fill(dailyCompliment.compliment.type.color2)
                                    )
                                
                                Spacer()
                                Text(DateFormatterManager.shared.dayOfWeek(from: dailyCompliment.date))
                                    .font(.suite(.medium, size: 12))
                                    .foregroundStyle(Color.gray4)
                                
                                Button {
//                                    archiveViewModel.toggleArchive(id: dailyCompliment.id)
                                } label: {
                                    ZStack {
                                        Image("Flower Default Default")
                                        
                                        if dailyCompliment.isArchived {
                                            Image("Flower Pressed")
                                        }
                                    }
                                }
                            }
                            
                            Text("\(dailyCompliment.compliment.content)")
                                .font(.suite(.medium, size: 14))
                                .foregroundStyle(Color.gray9)
                        }
                        .padding(.horizontal, 17)
                        .padding(.vertical, 25)
                        .background(dailyCompliment.compliment.type.color1)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.bottom, 18)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        calendarViewModel.selectDate = dailyCompliment.date
                        complimentViewModel.dailyCompliment = dailyCompliment
                    })
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

struct ArchiveHeaderView: View {
    @ObservedObject var calendarViewModel: CalendarViewModel
    @Binding var selectedPick: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                calendarViewModel.shouldShowMonthPicker = true
            } label: {
                HStack(spacing: 2) {
                    Text(DateFormatterManager.shared.yearMonth(from: calendarViewModel.month))
                        .font(.suite(.bold, size: 17))
                        .foregroundStyle(Color.gray8)
                    
                    Image("Arrow down Default")
                        .frame(width: 20, height: 20)
                }
            }
            .padding(.bottom)
            
            CustomSegmentedControl(items: ["일력", "칭찬카드"], cornerRadius: 8, selection: $selectedPick)
                .frame(maxWidth: .infinity)
                .frame(height: 37)
                .padding(.bottom)
        }
    }
}
