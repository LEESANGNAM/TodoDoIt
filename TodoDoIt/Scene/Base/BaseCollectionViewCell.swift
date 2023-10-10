//
//  BaseCollectionViewCell.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/09/27.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Design.Color.cell
        layer.cornerRadius = 10

        setHierarchy()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setHierarchy(){ }
    func setConstraints(){ }
    
    
}
