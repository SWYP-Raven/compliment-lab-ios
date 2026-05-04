//
//  HandCopyingViewModel.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/24/25.
//

import Foundation

final class ComplimentViewModel: ObservableObject {
    @Published var complimentList: [DailyCompliment] = []
    @Published var dailyCompliment: DailyCompliment?
    @Published var copyingSuccess: Bool = false
    @Published var flowerPressed: Bool = false

    private var userUID: String
    private var recordRepository: ComplimentRecordRepository?
    private var pendingLoadYear: Int?
    private var pendingLoadMonth: Int?
    private var pendingWeekDates: [CalendarDate]?

    func toggleArchive() {
        dailyCompliment?.isArchived.toggle()
    }

    init() {
        if let saved = UserDefaults.standard.string(forKey: "deviceUID") {
            self.userUID = saved
        } else {
            let newUID = UUID().uuidString
            UserDefaults.standard.set(newUID, forKey: "deviceUID")
            self.userUID = newUID
        }
    }

    func configure(userId: String) {
        self.userUID = userId
        let repo = ComplimentRecordRepository(userId: userId)
        self.recordRepository = repo
        Task { @MainActor [weak self] in
            await repo.fetchAllRecordsIfNeeded()
            guard let self else { return }
            if let year = self.pendingLoadYear, let month = self.pendingLoadMonth {
                self.loadLocalMonthlyCompliment(year: year, month: month)
            }
            if let weekDates = self.pendingWeekDates {
                self.loadLocalWeeklyCompliment(weekDates: weekDates)
            }
        }
    }

    func fetchMonthlyCompliment(year: Int, month: Int) {
        let todayYear = Calendar.current.component(.year, from: Date())
        let todayMonth = Calendar.current.component(.month, from: Date())
        guard !(year > todayYear || (year == todayYear && month > todayMonth)) else { return }
        pendingLoadYear = year
        pendingLoadMonth = month
        loadLocalMonthlyCompliment(year: year, month: month)
    }

    func fetchWeeklyCompliment(weekDates: [CalendarDate]) {
        let today = Calendar.current.startOfDay(for: Date())
        guard let start = weekDates.first?.date,
              Calendar.current.startOfDay(for: start) <= today else { return }
        pendingWeekDates = weekDates
        loadLocalWeeklyCompliment(weekDates: weekDates)
    }

    func patchCompliment(isArchived: Bool, isRead: Bool, date: Date) {
        let key = ComplimentLocalDataSource.dateKey(for: date)
        recordRepository?.setArchived(isArchived, for: key)
        recordRepository?.setRead(isRead, for: key)
        dailyCompliment?.isRead = isRead
        dailyCompliment?.isArchived = isArchived
    }

    // MARK: - Local

    func resolvedCompliment(for date: Date) -> DailyCompliment {
        return makeDailyCompliment(for: date)
    }

    private func loadLocalMonthlyCompliment(year: Int, month: Int) {
        let calendar = Calendar.current
        var components = DateComponents(year: year, month: month)
        guard let firstDate = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: firstDate) else { return }

        let today = calendar.startOfDay(for: Date())
        let dates: [Date] = range.compactMap { day in
            components.day = day
            return calendar.date(from: components)
        }.filter { calendar.startOfDay(for: $0) <= today }

        complimentList = dates.map { makeDailyCompliment(for: $0) }
    }

    private func loadLocalWeeklyCompliment(weekDates: [CalendarDate]) {
        let today = Calendar.current.startOfDay(for: Date())
        complimentList = weekDates
            .map { $0.date }
            .filter { Calendar.current.startOfDay(for: $0) <= today }
            .map { makeDailyCompliment(for: $0) }
    }

    private func makeDailyCompliment(for date: Date) -> DailyCompliment {
        let compliment = ComplimentLocalDataSource.compliment(for: date, userUID: userUID)
        let key = ComplimentLocalDataSource.dateKey(for: date)
        return DailyCompliment(
            compliment: compliment,
            date: date,
            isArchived: recordRepository?.isArchived(for: key) ?? false,
            isRead: recordRepository?.isRead(for: key) ?? false
        )
    }

    // MARK: - 한글 완성형 분해 (TracingTextView용)

    /**
     종성 = 완성형 % 28
     중성 = ((완성형 - 종성) / 28) % 21
     초성 = (((완성형 - 종성) / 28) - 중성) / 21
     */
    func decomposeSyllable(_ ch: Character) -> (L: Int, V: Int, T: Int)? {
        guard let s = ch.unicodeScalars.first?.value, (0xAC00...0xD7A3).contains(s) else { return nil }
        let idx = Int(s - 0xAC00)
        let T = idx % 28
        let V = ((idx - T) / 28) % 21
        let L  = (((idx - T) / 28) - V) / 21
        return (L, V, T)
    }

    // 호환 자모 → 인덱스 매핑(초/중/종성)
    func isAcceptablePrefix(target: Character, input: Character, nextTarget: Character? = nil) -> Bool {
        if target == " " { return input == " " }
        if input == " " { return false }

        // 완성형을 초/중/종성으로 분해
        guard let (targetL, targetV, targetT) = decomposeSyllable(target) else {
            return target == input
        }

        // 입력이 완성형이면 분해해서 접두 비교
        if let (inputL, inputV, inputT) = decomposeSyllable(input) {
            // 초성이 다르면 무조건 불일치
            guard inputL == targetL else { return false }

            // 중성이 같거나, target 중성이 겹모음이고 입력이 그 겹모음의 첫 성분이면 허용
            // 예) target: ㅘ, input: ㅗ -> OK, target: ㅏ, input: ㅗ -> X
            guard inputV == targetV || (Syllable.firstOfCompoundV[targetV] == inputV) else {
                return false
            }

            // 종성이 아직 없으면 -> OK
            if inputT == 0 { return true }

            // 종성까지 완전히 같으면 → OK
            if inputT == targetT { return true }

            // 겹받침 첫 성분이면 -> OK
            // 예) target: "읽"(종성 ㄺ), input: "일"(종성 ㄹ)
            if let first = Syllable.firstOfCompoundT[targetT], inputT == first { return true }

            // 받침 이월 예외
            // 예) input: 갈, next: 라
            if let next = nextTarget, let (Ln, _, _) = decomposeSyllable(next),
               let expectedL = Syllable.TIndexToLIndex[inputT], expectedL == Ln {
                return true
            }
            return false
        }

        // 입력이 자모(호환 자모)라면: 초성만 OK (모음 단독/종성 단독은 NG)
        if let l = Syllable.initialConsonantMap[input] {
            return l == targetL
        }

        if Syllable.medialVowelMap[input] != nil { return false }
        if Syllable.finalConsonantMap[input] != nil { return false }

        // 기타 문자는 완전 일치만
        return target == input
    }
}

enum Syllable {
    static let startInitialConsonantUnicode = 0x1100
    static let startMedialVowelUnicode = 0x314F
    static let startFinalConsonantUnicode = 0x11A8

    static let countOfInitialConsonant: UInt32 = 19
    static let countOfMedialVowel: UInt32 = 21
    static let countOfFinalConsonant: UInt32 = 27

    static var initialConsonantMap: [Character: Int] = ["ㄱ":0,"ㄲ":1,"ㄴ":2,"ㄷ":3,"ㄸ":4,"ㄹ":5,"ㅁ":6,"ㅂ":7,"ㅃ":8,"ㅅ":9,"ㅆ":10,"ㅇ":11,"ㅈ":12,"ㅉ":13,"ㅊ":14,"ㅋ":15,"ㅌ":16,"ㅍ":17,"ㅎ":18]

    static var medialVowelMap: [Character: Int] = ["ㅏ":0,"ㅐ":1,"ㅑ":2,"ㅒ":3,"ㅓ":4,"ㅔ":5,"ㅕ":6,"ㅖ":7,"ㅗ":8,"ㅘ":9,"ㅙ":10,"ㅚ":11,"ㅛ":12,"ㅜ":13,"ㅝ":14,"ㅞ":15,"ㅟ":16,"ㅠ":17,"ㅡ":18,"ㅢ":19,"ㅣ":20]

    static var finalConsonantList: [String] = [
        "", "ᆨ","ᆩ","ᆪ","ᆫ","ᆬ","ᆭ","ᆮ","ᆯ","ᆰ","ᆱ","ᆲ","ᆳ",
        "ᆴ","ᆵ","ᆶ","ᆷ","ᆸ","ᆹ","ᆺ","ᆻ","ᆼ","ᆽ","ᆾ","ᆿ","ᇀ","ᇁ","ᇂ"
    ]

    static let finalConsonantMap: [Character: Int] = {
        Dictionary(uniqueKeysWithValues:
            finalConsonantList.enumerated().compactMap { i, s in
                guard !s.isEmpty, let c = s.first else { return nil }
                return (c, i)
            }
        )
    }()

    static let TIndexToLIndex: [Int: Int] = [
        1:0, 2:1, 3:9, 4:2, 5:12, 6:18, 7:3, 8:5, 9:0, 10:6, 11:7, 12:9, 13:16, 14:17, 15:18, 16:6, 17:7, 18:9, 19:9, 20:10, 21:11, 22:12, 23:14, 24:15, 25:16, 26:17, 27:18
    ]

    static let firstOfCompoundT: [Int: Int] = [
        3:1, 5:4, 6:4, 9:8, 10:8, 11:8, 12:8, 13:8, 14:8, 15:8, 18:17
    ]

    static let firstOfCompoundV: [Int: Int] = [
        9:8, 10:8, 11:8, 14:13, 15:13, 16:13, 19:18
    ]
}
