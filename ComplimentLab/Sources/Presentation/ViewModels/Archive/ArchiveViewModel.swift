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
    @Published var isLoading = false

    let chatUseCase: ChatUseCase
    let disposeBag = DisposeBag()

    private var userUID: String = ""
    private var recordRepository: ComplimentRecordRepository?

    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    init(chatUseCase: ChatUseCase) {
        self.chatUseCase = chatUseCase
    }

    func configure(userId: String) {
        self.userUID = userId
        self.recordRepository = ComplimentRecordRepository(userId: userId)
    }

    func getArchivedCompliments(year: Int, month: Int) {
        guard let repo = recordRepository else { return }
        isLoading = true
        Task { @MainActor [weak self] in
            guard let self else { return }
            await repo.fetchAllRecords()
            let records = repo.archivedRecords()
            let items = records.compactMap { record -> DailyCompliment? in
                guard let date = self.dateFormatter.date(from: record.date) else { return nil }
                let comps = Calendar.current.dateComponents([.year, .month], from: date)
                guard comps.year == year, comps.month == month else { return nil }
                let compliment = ComplimentLocalDataSource.compliment(for: date, userUID: self.userUID)
                return DailyCompliment(compliment: compliment, date: date, isArchived: true, isRead: record.isRead)
            }
            self.archivedCompliments = self.sortCompliments(items, by: self.sortType)
            self.isLoading = false
        }
    }

    func patchArchived(_ isArchived: Bool, isRead: Bool, date: Date) {
        let key = ComplimentLocalDataSource.dateKey(for: date)
        recordRepository?.setArchived(isArchived, for: key)
        recordRepository?.setRead(isRead, for: key)
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

