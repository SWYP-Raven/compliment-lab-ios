//
//  ComplimentRecordRepository.swift
//  ComplimentLab
//

import Foundation
import FirebaseFirestore

final class ComplimentRecordRepository {
    private let db = Firestore.firestore()
    private let userId: String
    private var cache: [String: Record] = [:]
    private var isFetched = false

    struct Record {
        var isRead: Bool
        var isArchived: Bool
    }

    init(userId: String) {
        self.userId = userId
    }

    func fetchAllRecordsIfNeeded() async {
        guard !isFetched else { return }
        await fetchAllRecords()
    }

    func fetchAllRecords() async {
        isFetched = true
        let snapshot = try? await db
            .collection("users").document(userId)
            .collection("records")
            .getDocuments()
        cache = snapshot?.documents.reduce(into: [:]) { acc, doc in
            acc[doc.documentID] = Record(
                isRead: doc.data()["isRead"] as? Bool ?? false,
                isArchived: doc.data()["isArchived"] as? Bool ?? false
            )
        } ?? [:]
    }

    func isRead(for dateKey: String) -> Bool { cache[dateKey]?.isRead ?? false }
    func isArchived(for dateKey: String) -> Bool { cache[dateKey]?.isArchived ?? false }

    func archivedRecords() -> [(date: String, isRead: Bool)] {
        cache.filter { $0.value.isArchived }.map { (date: $0.key, isRead: $0.value.isRead) }
    }

    func setRead(_ isRead: Bool, for dateKey: String) {
        var record = cache[dateKey] ?? Record(isRead: false, isArchived: false)
        record.isRead = isRead
        cache[dateKey] = record
        write(dateKey: dateKey)
    }

    func setArchived(_ isArchived: Bool, for dateKey: String) {
        var record = cache[dateKey] ?? Record(isRead: false, isArchived: false)
        record.isArchived = isArchived
        cache[dateKey] = record
        write(dateKey: dateKey)
    }

    private func write(dateKey: String) {
        guard let record = cache[dateKey] else { return }
        db.collection("users").document(userId)
            .collection("records").document(dateKey)
            .setData(["isRead": record.isRead, "isArchived": record.isArchived])
    }

    func deleteAll() async {
        let ref = db.collection("users").document(userId).collection("records")
        guard let snapshot = try? await ref.getDocuments() else { return }
        let batch = db.batch()
        snapshot.documents.forEach { batch.deleteDocument($0.reference) }
        try? await batch.commit()
    }
}
