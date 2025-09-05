//
//  ComplimentUsecase.swift
//  ComplimentLab
//
//  Created by wayblemac02 on 9/4/25.
//

import Foundation
import RxSwift

protocol ComplimentUseCase {
    func getMonthlyCompliment(date: String) -> Observable<[DailyCompliment]>
    func getWeeklyCompliment(startDate: String, endDate: String) -> Observable<[DailyCompliment]>
    func patchCompliment(editComplimentDTO: EditComplimentDTO, date: String) -> Observable<Void>
}
