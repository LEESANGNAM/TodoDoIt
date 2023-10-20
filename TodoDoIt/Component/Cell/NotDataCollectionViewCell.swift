//
//  NodataCollectionViewCell.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/18.
//

import Foundation

import UIKit

class NotDataCollectionViewCell: BaseCollectionViewCell{
    var titleLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: Design.Font.contentFontSize)
        view.textColor = Design.Color.whiteFont
        return view
    }()
    
    override func setHierarchy() {
        addSubview(titleLabel)
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(5)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
    }
    
    func setupData(section: SectionType){
        switch section {
        case .doit:
            titleLabel.text = "도전중인" + section.title + "가 없습니다."
        case .todo:
            titleLabel.text = section.title + "이 없습니다."
        case .memo:
            titleLabel.text = section.title + "가 없습니다."
        }
    }
    
}
