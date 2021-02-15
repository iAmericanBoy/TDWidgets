//
//  Date+Extension.swift
//  TDWidgets
//
//  Created by Dominic Lanzillotta on 2/14/21.
//

import Foundation

extension Date {
    static var tomorrow:  Date { return Date().dayAfter }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: fourAM)!
    }
    var fourAM: Date {
        return Calendar.current.date(bySettingHour: 4, minute: 0, second: 0, of: self)!
    }
    var eightPM: Date {
        return Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: self)!
    }
}
