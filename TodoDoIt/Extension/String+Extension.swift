//
//  String+Extension.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/04.
//

import UIKit

extension String {
    func removeSpace() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    func strikeThrough() -> NSAttributedString {
           let attributeString = NSMutableAttributedString(string: self)
           attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
           return attributeString
       }
}
