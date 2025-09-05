//
//  HandCopyingViewModel.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/24/25.
//

import Foundation
import RxSwift

final class ComplimentViewModel: ObservableObject {
    @Published var complimentList: [DailyCompliment] = []
    @Published var dailyCompliment: DailyCompliment?
    @Published var copyingSuccess: Bool = false
    @Published var flowerPressed: Bool = false
    
    let useCase: ComplimentUseCase
    let disposeBag = DisposeBag()
    
    let sentence: String = "오늘도 한 발자국 나아갔네요.\n그 걸음이 모여 더 큰 변화를 만들 거예요!"
    
    func toggleArchive() {
        dailyCompliment?.isArchived.toggle()
    }
    
    init(useCase: ComplimentUseCase) {
        self.useCase = useCase
    }
    
    func fetchMonthlyCompliment(year: Int, month: Int) {
        let date = "\(year)-\(String(format: "%02d", month))"
        guard let accessToken = KeychainStorage.shared.getToken()?.accessToken else {
            return
        }
        
        useCase.getMonthlyCompliment(date: date, token: accessToken)
            .subscribe(onNext: { [weak self] items in
                self?.complimentList = items
            })
            .disposed(by: disposeBag)
    }
    
    func fetchWeeklyCompliment(weekDates: [CalendarDate]) {
        guard let start = weekDates.first?.date, let end = weekDates.last?.date, let accessToken = KeychainStorage.shared.getToken()?.accessToken else { return }
        
        useCase.getWeeklyCompliment(
            startDate: DateFormatterManager.shared.apiDate(from: start),
            endDate: DateFormatterManager.shared.apiDate(from: end),
            token: accessToken
        )
        .subscribe(onNext: { [weak self] items in
            self?.complimentList = items
        })
        .disposed(by: disposeBag)
    }
    
    func patchCompliment(isArchived: Bool, isRead: Bool, date: Date) {
        let editComplimentDTO = EditComplimentDTO(isArchived: isArchived, isRead: isRead)
        guard let accessToken = KeychainStorage.shared.getToken()?.accessToken else {
            return
        }
        
        useCase.patchCompliment(
            editComplimentDTO: editComplimentDTO,
            date: DateFormatterManager.shared.apiDate(from: date),
            token: accessToken
        )
            .subscribe(
                onNext: {
                    print("PATCH 성공!")
                },
                onError: { error in
                    print("PATCH 실패: \(error)")
                }
            )
            .disposed(by: disposeBag)
    }
    
    // 한글 완성형 분해: (초/중/종) 인덱스
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
        
        if Syllable.medialVowelMap[input] != nil { return false }   // 중성 단독 불허
        if Syllable.finalConsonantMap[input] != nil { return false }   // 종성 단독 불허

        // 기타 문자는 완전 일치만
        return target == input
    }
}

enum Syllable {
    // 계산해서 쓰려했으나 유니코드 0x1100과 input 유니코드 0x3131과 차이가 있는 이슈로 인해 하드코딩
    static let startInitialConsonantUnicode = 0x1100
    static let startMedialVowelUnicode = 0x314F
    static let startFinalConsonantUnicode = 0x11A8
    
    static let countOfInitialConsonant: UInt32 = 19
    static let countOfMedialVowel: UInt32 = 21
    static let countOfFinalConsonant: UInt32 = 27
    
    /// 초성에 올 자음 ㄱ...ㅎ (19개)
    static var initialConsonantMap: [Character: Int] = ["ㄱ":0,"ㄲ":1,"ㄴ":2,"ㄷ":3,"ㄸ":4,"ㄹ":5,"ㅁ":6,"ㅂ":7,"ㅃ":8,"ㅅ":9,"ㅆ":10,"ㅇ":11,"ㅈ":12,"ㅉ":13,"ㅊ":14,"ㅋ":15,"ㅌ":16,"ㅍ":17,"ㅎ":18]
    
    /// 모음 ㅏ...ㅣ(21개)
    static var medialVowelMap: [Character: Int] = ["ㅏ":0,"ㅐ":1,"ㅑ":2,"ㅒ":3,"ㅓ":4,"ㅔ":5,"ㅕ":6,"ㅖ":7,"ㅗ":8,"ㅘ":9,"ㅙ":10,"ㅚ":11,"ㅛ":12,"ㅜ":13,"ㅝ":14,"ㅞ":15,"ㅟ":16,"ㅠ":17,"ㅡ":18,"ㅢ":19,"ㅣ":20]
    
    /// 종성에 올 자음 ㄱㄲ...ㅍㅎ(27개) + 1개(없는경우)
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
