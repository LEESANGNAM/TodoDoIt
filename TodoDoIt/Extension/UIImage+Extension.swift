//
//  UIImage+Extension.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/13.
//

import Foundation
import UIKit

extension UIImage {
    func downsampling(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
