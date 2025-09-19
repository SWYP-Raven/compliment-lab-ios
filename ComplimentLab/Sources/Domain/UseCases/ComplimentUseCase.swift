//
//  ComplimentUsecase.swift
//  ComplimentLab
//
//  Created by 이인호 on 9/4/25.
//

import Foundation
import RxSwift

protocol ComplimentUseCase {
    func getMonthlyCompliment(date: String, token: String) -> Observable<[DailyCompliment]>
    func getWeeklyCompliment(startDate: String, endDate: String, token: String) -> Observable<[DailyCompliment]>
    func patchCompliment(editComplimentDTO: EditComplimentDTO, date: String, token: String) -> Observable<Void>
    func archivedCompliment(date: String, token: String) -> Observable<[DailyCompliment]>
}
