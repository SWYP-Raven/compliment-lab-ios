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
    @Published var compliments: [Compliment] = Compliment.mockCompliments
    
    func getArchivedCompliments(token: String, date: Date) {
        
    }
    
    func sortByDate(type: SortType) {
        if type == .recent {
            compliments = compliments.sorted { $0.date > $1.date }
        } else {
            compliments = compliments.sorted { $0.date < $1.date }
        }
    }
}

