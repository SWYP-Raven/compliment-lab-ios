//
//  ArchiveHeaderView.swift
//  ComplimentLab
//
//  Created by 이인호 on 9/15/25.
//

import SwiftUI

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
