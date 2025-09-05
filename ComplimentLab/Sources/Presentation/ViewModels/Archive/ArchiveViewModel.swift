//
//  ArchiveViewModel.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/27/25.
//

import Foundation
import RxSwift

enum SortType {
    case recent
    case past
}

final class ArchiveViewModel: ObservableObject {
    @Published var archivedCompliments: [DailyCompliment] = []
    
    let useCase: ComplimentUseCase
    let disposeBag = DisposeBag()
    
    init(useCase: ComplimentUseCase) {
        self.useCase = useCase
    }
    
    func getArchivedCompliments(year: Int, month: Int) {
        let date = "\(year)-\(String(format: "%02d", month))"
        guard let accessToken = KeychainStorage.shared.getToken()?.accessToken else {
            return
        }
        
        useCase.archivedCompliment(date: date, token: accessToken)
            .subscribe(onNext: { [weak self] items in
                self?.archivedCompliments = items
            })
            .disposed(by: disposeBag)
    }
    
    func sortByDate(type: SortType) {
        if type == .recent {
            archivedCompliments = archivedCompliments.sorted { $0.date > $1.date }
        } else {
            archivedCompliments = archivedCompliments.sorted { $0.date < $1.date }
        }
    }
}

