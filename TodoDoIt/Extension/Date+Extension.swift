//
//  Date+Extension.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/09/28.
//

import Foundation

extension Date {
    func changeFormatString(format: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    // 같은날 인지 파악 시간제외
    func isSameDay(as date: Date) -> Bool {
           let calendar = Calendar.current
           let components1 = calendar.dateComponents([.year, .month, .day], from: self)
           let components2 = calendar.dateComponents([.year, .month, .day], from: date)
           return components1 == components2
       }
}
