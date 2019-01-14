//
//  Date+.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 1/14/19.
//  Copyright © 2019 Framgia. All rights reserved.
//

import UIKit

extension DateFormatter {
    enum Format: String {
        case iso8601 = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        case date = "yyyy-MM-dd"
        
        static let defaultCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
        static let defaultLocale = Locale(identifier: "en_US_POSIX")
        static let japaneseLocale = Locale(identifier: "ja_JP")
        
        var instance: DateFormatter {
            switch self {
            default:
                return DateFormatter().then {
                    $0.dateFormat = self.rawValue
                    $0.calendar = Format.defaultCalendar
                    $0.locale = Format.defaultLocale
                }
            }
        }
        
        var japaneseInstance: DateFormatter {
            switch self {
            default:
                return DateFormatter().then {
                    $0.dateFormat = self.rawValue
                    $0.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
                    $0.locale = Locale(identifier: "ja_JP_POSIX")
                }
            }
        }
    }
}

extension Date {
    func dateString() -> String {
        return DateFormatter.Format.date.instance.string(from: self)
    }
}
