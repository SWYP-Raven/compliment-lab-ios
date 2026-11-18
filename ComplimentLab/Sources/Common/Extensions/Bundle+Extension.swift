//
//  Bundle+Extension.swift
//  ComplimentLab
//
//  Created by 이인호 on 11/18/26.
//

import Foundation

extension Bundle {
    // Project.swift 의 MARKETING_VERSION 이 Info.plist 로 주입된 값을 읽는다
    var appVersion: String {
        object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
}
