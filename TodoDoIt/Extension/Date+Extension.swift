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
}
