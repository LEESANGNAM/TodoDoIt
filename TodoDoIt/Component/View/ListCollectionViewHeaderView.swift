//
//  ListCollectionViewHeaderView.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/09/27.
//

import UIKit
import SnapKit

class ListCollectionViewHeaderView: UICollectionReusableView {
    let addButton = {
        let button = UIButton()
        button.setTitle("test", for: .normal)
//        button.setImage(Design.Image.plusButton, for: .normal)
        
        var configuration = UIButton.Configuration.gray()
        // 이미지와 타이틀을 아래로 배치
        configuration.image = Design.Image.plusButton
        configuration.imagePlacement = NSDirectionalRectEdge.trailing
        configuration.baseForegroundColor = Design.Color.blackFont
        configuration.buttonSize = .mini
        configuration.titlePadding = -10
        configuration.imagePadding = 10
        configuration.cornerStyle = .capsule
        
        button.configuration = configuration
        button.sizeToFit()
        
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
        addSubview(addButton)
        addSubview(listButton)
    }
    func setConstraints(){        
        addButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        listButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
            make.height.equalTo(30)
        }
        
    }
    
    
}
