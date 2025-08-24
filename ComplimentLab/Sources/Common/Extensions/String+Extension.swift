//
//  String+Extension.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/24/25.
//

import SwiftUI

extension String {
    func singleLineWidth(using font: UIFont) -> CGFloat {
        let attrs: [NSAttributedString.Key: Any] = [.font: font]
        return ceil((self as NSString).size(withAttributes: attrs).width)
    }
}
