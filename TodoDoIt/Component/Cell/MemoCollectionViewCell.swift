//
//  MemoCollectionViewCell.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/02.
//

import UIKit

class MemoCollectionViewCell: BaseCollectionViewCell{
    var titleLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: Design.titleFontSize)
        return view
    }()
    
    override func setHierarchy() {
        addSubview(titleLabel)
        backgroundColor = .brown
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    func setupData(memo: Memo){
        titleLabel.text = memo.title
    }
    
}
