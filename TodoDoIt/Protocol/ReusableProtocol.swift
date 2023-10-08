//
//  ReusableProtocol.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/09.
//

import UIKit

protocol ResusableProtocol {
static var identifier: String { get }
}

extension NSObject: ResusableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
