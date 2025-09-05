//
//  CustomTabView.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/17/25.
//

import SwiftUI

struct CustomTabView: View {
    @StateObject var calendarViewModel = CalendarViewModel()
    @StateObject var complimentViewModel = ComplimentViewModel(useCase: ComplimentAPI())
    @StateObject var friendsViewModel = FriendsViewModel()
    @State private var selection = 0
    @State private var showCreateFriends = false
    
    init() {
        UITabBarItem.appearance().setTitleTextAttributes([
            .font: UIFont(name: "SUITE-Medium", size: 12)!,
            .foregroundColor: UIColor(Color.gray4)
        ], for: .normal)

        UITabBarItem.appearance().setTitleTextAttributes([
            .font: UIFont(name: "SUITE-Medium", size: 12)!,
            .foregroundColor: UIColor(Color.gray9)
        ], for: .selected)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                TabView(selection: $selection) {
                    CalendarView(calendarViewModel: calendarViewModel, complimentViewModel: complimentViewModel, selection: $selection)
                        .tabItem {
                            selection == 0 ? Image("Home Pressed") : Image("Home Default")
                            Text("일력")
                        }
                        .tag(0)

                    FriendView()
                        .tabItem {
                            selection == 1 ? Image("Chat Pressed") : Image("Chat Default")
                            Text("칭구")
                        }
                        .tag(1)
                    
                    ArchiveView(calendarViewModel: calendarViewModel, complimentViewModel: complimentViewModel)
                        .tabItem {
                            selection == 2 ? Image("Archive Pressed") : Image("Archive Default")
                            Text("기록")
                        }
                        .tag(2)
                    
                    SettingView()
                        .tabItem {
                            selection == 3 ? Image("My Pressed") : Image("My Default")
                            Text("마이")
                        }
                        .tag(3)
                }
                
                if calendarViewModel.shouldShowMonthPicker {
                    Color.backgroundGray
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            calendarViewModel.shouldShowMonthPicker = false
                        }
                    
                    YearMonthPickerView(calendarViewModel: calendarViewModel, pickerYear: calendarViewModel.selectedYear)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(35)
                }
            }
            .navigationDestination(isPresented: $calendarViewModel.isButtonTapped) {
                TodayComplimentView(calendarViewModel: calendarViewModel, complimentViewModel: complimentViewModel)
            }
        }
    }
}

#Preview {
    CustomTabView()
}
