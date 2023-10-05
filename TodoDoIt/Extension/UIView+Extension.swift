//
//  UIView+Extension.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/06.
//

import UIKit


extension UIView {
    // 코너 지정
    func roundCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
            clipsToBounds = true
            layer.cornerRadius = cornerRadius
            layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
        }
}
