//
//  DailyCalendarArchiveView.swift
//  ComplimentLab
//
//  Created by 이인호 on 9/15/25.
//

import SwiftUI

struct DailyCalendarArchiveView: View {
    @ObservedObject var archiveViewModel: ArchiveViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    @ObservedObject var complimentViewModel: ComplimentViewModel
    
    var body: some View {
        if archiveViewModel.archivedCompliments.isEmpty {
            VStack {
                Spacer()
                Image("daily X")
                Text("마음에 드는 문장을 저장해보세요!\n곧 가득 채워질 거예요:)")
                    .font(.suite(.semiBold, size: 14))
                    .foregroundStyle(Color.gray4)
                    .multilineTextAlignment(.center)
                Spacer()
            }
        } else {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(archiveViewModel.archivedCompliments, id: \.self) { dailyCompliment in
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
                                        let changedArchived = !dailyCompliment.isArchived
                                        
                                        if let index = archiveViewModel.archivedCompliments.firstIndex(where: { calendarViewModel.isSameDay(date1: $0.date, date2: dailyCompliment.date )}) {
                                            archiveViewModel.archivedCompliments[index].isArchived.toggle()
                                        }
                                        
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
}

