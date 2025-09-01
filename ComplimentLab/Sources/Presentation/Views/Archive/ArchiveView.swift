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
    @State var selectedPick = "일력"
    
    var body: some View {
        VStack {
            ArchiveHeaderView(calendarViewModel: calendarViewModel, selectedPick: $selectedPick)
            
            if selectedPick == "일력" {
                DailyCalendarArchive(archiveViewModel: archiveViewModel)
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
                    Image(systemName: "text.alignleft")
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
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(archiveViewModel.compliments, id: \.self) { compliment in
                    NavigationLink(destination: TodayComplimentView()) {
                        VStack(alignment: .leading, spacing: 22) {
                            HStack(alignment: .center) {
                                Image(systemName: "tree")
                                Spacer()
                                Text(changeDateFormat(date: compliment.date))
                                    .font(.suite(.medium, size: 12))
                                    .foregroundStyle(Color.gray4)
                                
                                Button {
                                } label: {
                                    ZStack {
                                        Image("Flower Default Default")
                                        
//                                        if flowerPressed {
//                                            Image("Flower Pressed")
//                                        }
                                    }
                                }
                            }
                            
                            Text("\(compliment.text)")
                                .font(.suite(.medium, size: 14))
                                .foregroundStyle(Color.gray9)
                        }
                        .padding(.horizontal, 17)
                        .padding(.vertical, 25)
                        .background(Color.pink1)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.bottom, 18)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
    
    func changeDateFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.dateFormat = "d EEEE"
        
        return formatter.string(from: date)
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
                    Text(calendarViewModel.yearMonthDateFormatter(in: calendarViewModel.month))
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

#Preview {
    ArchiveView(calendarViewModel: CalendarViewModel())
}

