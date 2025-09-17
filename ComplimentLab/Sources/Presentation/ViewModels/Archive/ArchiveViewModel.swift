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
    @Published var archivedCards: [Card] = []
    @Published var sortType: SortType = .recent
    
    let useCase: ComplimentUseCase
    let chatUseCase: ChatUseCase
    let disposeBag = DisposeBag()
    
    init(useCase: ComplimentUseCase, chatUseCase: ChatUseCase) {
        self.useCase = useCase
        self.chatUseCase = chatUseCase
    }
    
    func getArchivedCompliments(year: Int, month: Int) {
        let date = "\(year)-\(String(format: "%02d", month))"
        guard let accessToken = KeychainStorage.shared.getToken()?.accessToken else {
            return
        }
        
        useCase.archivedCompliment(date: date, token: accessToken)
            .subscribe(onNext: { [weak self] items in
                guard let self else { return }
                self.archivedCompliments = self.sortCompliments(items, by: self.sortType)
            })
            .disposed(by: disposeBag)
    }
    
    func getArchivedCards(year: Int, month: Int) {
        let date = "\(year)-\(String(format: "%02d", month))"
        
        guard let accessToken = KeychainStorage.shared.getToken()?.accessToken else {
            return
        }
        
        chatUseCase.getCard(date: date, token: accessToken)
            .subscribe(onNext: { [weak self] items in
                guard let self else { return }
                self.archivedCards = self.sortCards(items, by: self.sortType)
            })
            .disposed(by: disposeBag)
    }
    
    private func sortCompliments(_ items: [DailyCompliment], by type: SortType) -> [DailyCompliment] {
        switch type {
        case .recent:
            return items.sorted { $0.date > $1.date }
        case .past:
            return items.sorted { $0.date < $1.date }
        }
    }

    private func sortCards(_ items: [Card], by type: SortType) -> [Card] {
        switch type {
        case .recent:
            return items.sorted { $0.createdAt > $1.createdAt }
        case .past:
            return items.sorted { $0.createdAt < $1.createdAt }
        }
    }
    
    func sortByDate(type: SortType) {
        sortType = type
        archivedCompliments = sortCompliments(archivedCompliments, by: type)
        archivedCards = sortCards(archivedCards, by: type)
    }
}

