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
        view.font = .systemFont(ofSize: Design.Font.dateFontSize)
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
    
    func setupData(memo: Memo){
        titleLabel.text = memo.title
    }
    
}
