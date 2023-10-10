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
        view.font = .systemFont(ofSize: Design.Font.contentFontSize)
        view.textColor = Design.Color.whiteFont
        return view
    }()
    let checkboxButton: UIButton = {
        let button = UIButton(type: .custom)
           button.setImage(UIImage(systemName: "square"), for: .normal)
            button.tintColor = Design.Color.whiteFont
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
            make.verticalEdges.equalToSuperview().inset(5)
            make.trailing.equalToSuperview()
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(10)
            make.size.equalTo(50)
        }
    }
    
    func setupData(todo: Todo){
        titleLabel.text = todo.title
        if todo.finish {
            checkboxButton.isSelected = true
        }else {
            checkboxButton.isSelected = false
        }
    }
}
