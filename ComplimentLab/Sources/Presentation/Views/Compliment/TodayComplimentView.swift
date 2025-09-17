//
//  TodayComplimentView.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/18/25.
//

import SwiftUI

struct TodayComplimentView: View {
    @StateObject private var toastManager = ToastManager()
    @ObservedObject var calendarViewModel: CalendarViewModel
    @ObservedObject var complimentViewModel: ComplimentViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            if var dailyCompliment = complimentViewModel.dailyCompliment {
                // 배경
                dailyCompliment.compliment.type.color1
                    .ignoresSafeArea()
                
                VStack {
                    YearHeaderView(date: dailyCompliment.date)
                    
                    VStack(spacing: 26) {
                        FlowerView(date: dailyCompliment.date)
                        
                        VStack(spacing: 28) {
                            let isToday = calendarViewModel.isSameDay(
                                date1: calendarViewModel.selectDate,
                                date2: calendarViewModel.today
                            )
                            
                            if isToday {
                                NavigationLink {
                                    HandCopyingView(complimentViewModel: complimentViewModel)
                                } label: {
                                    ComplimentTextView(sentence: dailyCompliment.compliment.content)
                                }
                                .buttonStyle(PlainButtonStyle())
                            } else {
                                Button {
                                    toastManager.show(message: "앗, 오늘의 칭찬만 따라 쓸 수 있어요")
                                } label: {
                                    ComplimentTextView(sentence: dailyCompliment.compliment.content)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            Image("logo home")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 17)
                    .padding(.vertical, 25)
                    .background(dailyCompliment.compliment.type.color2)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.bottom, 15)
                    .overlay(
                        dailyCompliment.compliment.type.stickerLImage
                            .padding(.top, 25)
                            .padding(.leading, 17),
                        alignment: .topLeading
                    )
                    
                    HStack(spacing: 21) {
                        Spacer()
                        
                        Button {
                            let changedArchived = !dailyCompliment.isArchived
                            complimentViewModel.toggleArchive()
                            complimentViewModel.patchCompliment(
                                isArchived: changedArchived,
                                isRead: dailyCompliment.isRead,
                                date: dailyCompliment.date
                            )
                        } label: {
                            ZStack {
                                Image("Flower Default Default")
                                
                                if dailyCompliment.isArchived {
                                    Image("Flower Pressed")
                                }
                            }
                        }
                        
                        let shareImageView = ComplimentShareView(
                            dailyCompliment: dailyCompliment
                        )
                        
                        if let swiftUIImage = shareImageView.snapshotImage() {
                            let photo = SharePhoto(image: swiftUIImage, caption: "오늘의 칭찬")
                            ShareLink(
                                item: photo,
                                preview: SharePreview(
                                    photo.caption,
                                    image: photo.image
                                )
                            ) {
                                Image("Send Default")
                            }
                        }
                    }
                    
                    Spacer()
                    
                    if toastManager.isShowing {
                        ToastView(message: toastManager.message, imageTitle: "Check Toast")
                            .padding(.bottom, 22)
                    }
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .task {
                    // 오늘 && 아직 확인하지 않은 경우
                    let isToday = calendarViewModel.isSameDay(
                        date1: calendarViewModel.selectDate,
                        date2: calendarViewModel.today
                    )
                    
                    if isToday && !dailyCompliment.isRead {
                        toastManager.show(message: "글자를 눌러 직접 입력해 보세요")
                        
                        complimentViewModel.patchCompliment(isArchived: dailyCompliment.isArchived, isRead: true, date: calendarViewModel.selectDate)
                        
                        dailyCompliment.isRead = true
                    }
                }
                .customNavigationBar(
                    leftView: {
                        Button {
                            dismiss()
                        } label: {
                            Image("Arrow left Default")
                        }
                    }
                )
            }
        }
    }
}

struct YearHeaderView: View {
    let date: Date
    
    var body: some View {
        VStack {
            Text(DateFormatterManager.shared.year(from: date))
                .font(.suite(.bold, size: 17))
                .foregroundStyle(Color.gray8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 18)
                .padding(.bottom, 15)
        }
    }
}

struct FlowerView: View {
    let date: Date
    
    var body: some View {
        VStack {
            Image("flower")
                .resizable()
                .scaledToFit()
                .frame(height: 260)
                .overlay(
                    VStack {
                        Text(DateFormatterManager.shared.monthEnglish(from: date))
                            .font(.suite(.bold, size: 17))
                            .foregroundStyle(Color.gray6)
                        Text(DateFormatterManager.shared.day(from: date))
                            .font(.suite(.heavy, size: 128))
                            .foregroundStyle(Color.gray10)
                    },
                    alignment: .center
                )
                .padding(.top, 43)
        }
    }
}

struct ComplimentTextView: View {
    private let sentence: String
    private var lines: [String] {
        sentence.components(separatedBy: "\n")
    }
    
    init(sentence: String) {
        self.sentence = sentence
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ExDivider()
            ForEach(lines, id: \.self) { line in
                Text(line)
                    .font(.suite(.semiBold, size: 15))
                
                if line != lines.last {
                    ExDivider()
                }
            }
            ExDivider()
        }
    }
}

struct ComplimentShareView: View {
    let dailyCompliment: DailyCompliment
    
    var body: some View {
        VStack(spacing: 26) {
            FlowerView(date: dailyCompliment.date)
            
            VStack(spacing: 28) {
                ComplimentTextView(sentence: dailyCompliment.compliment.content)
                Image("logo home")
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 17)
        .padding(.vertical, 25)
        .background(dailyCompliment.compliment.type.color2)
        .padding(.bottom, 15)
        .overlay(
            dailyCompliment.compliment.type.stickerLImage
                .padding(.top, 25)
                .padding(.leading, 17),
            alignment: .topLeading
        )
    }
}

struct SharePhoto: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.image)
    }
    
    public var image: Image
    public var caption: String
}
