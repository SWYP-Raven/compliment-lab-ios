//
//  Font+Extension.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/17/25.
//

import SwiftUI

extension Font {
    enum SuiteWeight: String {
        case bold = "SUITE-Bold"
        case extraBold = "SUITE-ExtraBold"
        case heavy = "SUITE-Heavy"
        case light = "SUITE-Light"
        case medium = "SUITE-Medium"
        case regular = "SUITE-Regular"
        case semiBold = "SUITE-SemiBold"
    }
    
    static func suite(_ weight: SuiteWeight, size: CGFloat) -> Font {
        return .custom(weight.rawValue, size: size)
    }
}

// 사용법
/*
 Text("Hello")
     .font(.suite(.medium, size: 16))
 */
