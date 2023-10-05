//
//  ListCollectionViewHeaderView.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/09/27.
//

import UIKit
import SnapKit

class ListCollectionViewHeaderView: UICollectionReusableView {
    var titleLabel = {
        let view = UILabel()
        view.text = "여기가 헤더뷰 타이틀"
        return view
    }()
    
    let addButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.sizeToFit()
        button.tintColor = .black
        return button
    }()
    let listButton = {
        let button = UIButton()
        button.setTitle("모두보기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: Design.Font.listButtonFontSize)
        button.setTitleColor(UIColor.systemGray, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setHierarchy()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setHierarchy(){
        addSubview(titleLabel)
        addSubview(addButton)
        addSubview(listButton)
    }
    func setConstraints(){
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        addButton.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing)
            make.centerY.equalToSuperview()
            make.size.equalTo(30)
        }
        
        listButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
            make.height.equalTo(30)
        }
        
    }
    
    
}
