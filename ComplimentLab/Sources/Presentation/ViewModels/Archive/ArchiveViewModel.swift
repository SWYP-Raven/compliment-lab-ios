//
//  ArchiveViewModel.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/27/25.
//

import Foundation

enum SortType {
    case recent
    case past
}

final class ArchiveViewModel: ObservableObject {
    @Published var dailyCompliments: [DailyCompliment] = DailyCompliment.mockCompliments
    
    func getArchivedCompliments(token: String, date: Date) {
        
    }
    
    func sortByDate(type: SortType) {
        if type == .recent {
            dailyCompliments = dailyCompliments.sorted { $0.date > $1.date }
        } else {
            dailyCompliments = dailyCompliments.sorted { $0.date < $1.date }
        }
    }
    
    func toggleArchive(id: String) {
        if let index = dailyCompliments.firstIndex(where: { $0.id == id }) {
            dailyCompliments[index].isArchived.toggle()
        }
    }
}

