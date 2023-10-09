//
//  TodoCollectionViewCell.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/02.
//

import UIKit

class TodoCollectionViewCell: BaseCollectionViewCell{
    var titleLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: Design.Font.titleFontSize)
        return view
    }()
    let checkboxButton: UIButton = {
           let button = UIButton(type: .system)
           button.setImage(UIImage(systemName: "square"), for: .normal)
           button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
           return button
       }()
    
    override func setHierarchy() {
        addSubview(titleLabel)
        addSubview(checkboxButton)
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.leading.equalToSuperview().offset(20)
        }
        checkboxButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().offset(-20)
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(10)
        }
    }
    
    func setupData(todo: Todo){
        titleLabel.text = todo.title
    }
    
}