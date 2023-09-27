//
//  BaseView.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/09/27.
//

import UIKit
import SnapKit

class BaseView: UIView{

    override init(frame: CGRect) {
        super.init(frame: frame)
        setHierarchy()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHierarchy() { }
    func setConstraints() { }
}
