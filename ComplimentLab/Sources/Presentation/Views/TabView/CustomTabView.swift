//
//  CustomTabView.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/17/25.
//

import SwiftUI

struct CustomTabView: View {
    @State private var selection = 0
    
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
        TabView(selection: $selection) {
            CalendarView()
                .tabItem {
                    selection == 0 ? Image("Home Pressed") : Image("Home Default")
                    Text("일력")
                }
                .tag(0)
            
            Color.clear
                .tabItem {
                    selection == 1 ? Image("Chat Pressed") : Image("Chat Default")
                    Text("칭구")
                }
                .tag(1)
            
            Color.clear
                .tabItem {
                    selection == 2 ? Image("Archive Pressed") : Image("Archive Default")
                    Text("기록")
                }
                .tag(2)
            
            Color.clear
                .tabItem {
                    selection == 3 ? Image("My Pressed") : Image("My Default")
                    Text("마이")
                }
                .tag(3)
        }
    }
}

#Preview {
    CustomTabView()
}
