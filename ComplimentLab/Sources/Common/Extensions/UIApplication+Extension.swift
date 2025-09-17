//
//  UIApplication+Extension.swift
//  ComplimentLab
//
//  Created by 이인호 on 8/24/25.
//

import SwiftUI

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?
            .endEditing(force)
    }
}
