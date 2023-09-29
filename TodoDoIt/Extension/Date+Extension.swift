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
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}
