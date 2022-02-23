//
//  Date+Extensions.swift
//  presentation
//
//  Created by Karim Karimov on 23.02.22.
//

import Foundation

extension Date {
    
    static func formatter(format: String, locale: Locale = Locale.init(identifier: "az-AZ")) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = locale
        return formatter
    }
    
    func formatted(format: String) -> String {
        return Date.formatter(format: format).string(from: self)
    }
}
