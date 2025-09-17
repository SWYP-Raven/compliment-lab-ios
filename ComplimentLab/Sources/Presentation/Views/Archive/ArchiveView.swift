//
//  ArchiveView.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/27/25.
//

import SwiftUI

struct ArchiveView: View {
    @ObservedObject var calendarViewModel: CalendarViewModel
    @ObservedObject var complimentViewModel: ComplimentViewModel
    @ObservedObject var archiveViewModel: ArchiveViewModel
    @StateObject var chatingViewModel = ChatingViewModel(useCase: ChatAPI())
    @State var selectedPick = "일력"
    
    var body: some View {
        VStack {
            ArchiveHeaderView(calendarViewModel: calendarViewModel, selectedPick: $selectedPick)
            
            if selectedPick == "일력" {
                DailyCalendarArchiveView(archiveViewModel: archiveViewModel, calendarViewModel: calendarViewModel, complimentViewModel: complimentViewModel)
                    .task {
                        archiveViewModel.getArchivedCompliments(
                            year: calendarViewModel.selectedYear,
                            month: calendarViewModel.selectedMonth
                        )
                    }
            } else {
                CardArchiveView(chatingViewModel: chatingViewModel, archiveViewModel: archiveViewModel)
                    .task {
                        archiveViewModel.getArchivedCards(
                            year: calendarViewModel.selectedYear,
                            month: calendarViewModel.selectedMonth
                        )
                    }
            }
        }
        .padding(.horizontal, 20)
        .customNavigationBar(
            rightView: {
                Menu {
                    Button {
                        archiveViewModel.sortByDate(type: .recent)
                    } label: {
                        Text("최근순")
                    }
                    Button {
                        archiveViewModel.sortByDate(type: .past)
                    } label: {
                        Text("이전순")
                    }
                } label: {
                    Image("list defalt")
                }
            }
        )
    }
}
