//
//  YearMonthPickerView.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/17/25.
//

import SwiftUI

struct YearMonthPickerView: View {
    @ObservedObject var calendarViewModel: CalendarViewModel
    let months: [String] = Calendar.current.shortMonthSymbols
    @State var pickerYear: Int
    
    var body: some View {
        VStack {
            HStack(spacing: 4) {
                Spacer()

                Button {
                    pickerYear -= 1
                } label: {
                    Image("Arrow left Default")
                }
                .opacity(pickerYear > 2025 ? 1 : 0)

                Text(String(pickerYear) + "년")
                    .font(.suite(.semiBold, size: 20))
                
                Button {
                    pickerYear += 1
                } label: {
                    Image("Arrow right Default")
                }
                
                Spacer()
            }
            .padding(.bottom, 16)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 3), spacing: 16) {
                ForEach(months.indices, id: \.self) { index in
                    if pickerYear == 2025 && index < 7 {
                        Text(months[index])
                        .font(.suite(.semiBold, size: 15))
                        .foregroundStyle(Color.gray4)
                        .frame(width: 80, height: 48)
                        .background(Color.gray1)
                        .clipShape(RoundedRectangle(cornerRadius: 100))
                    } else {
                        Button {
                            calendarViewModel.changeMonth(year: pickerYear, month: index + 1)
                            calendarViewModel.shouldShowMonthPicker = false
                        } label: {
                            Text(months[index])
                                .font(.suite(.semiBold, size: 15))
                                .foregroundStyle(pickerYear == calendarViewModel.selectedYear && index + 1 == calendarViewModel.selectedMonth ? Color.gray0 : Color.gray8)
                                .frame(width: 80, height: 48)
                        }
                        .background(pickerYear == calendarViewModel.selectedYear && index + 1 == calendarViewModel.selectedMonth ? Color.blue4 : Color.gray2)
                        .clipShape(RoundedRectangle(cornerRadius: 100))
                    }
                }
            }
        }
        .padding()
        .background(Color.gray0)
    }
}

#Preview {
    YearMonthPickerView(calendarViewModel: CalendarViewModel(), pickerYear: 2025)
}
