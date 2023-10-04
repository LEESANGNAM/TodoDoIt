//
//  String+Extension.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/04.
//

import Foundation

extension String {
    func removeSpace() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
}
