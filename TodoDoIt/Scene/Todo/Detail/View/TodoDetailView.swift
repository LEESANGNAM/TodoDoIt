//
//  TodoDetailView.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/11.
//

import UIKit


class TodoDetailView: BaseView {
    let titleLabel = {
        let view = UILabel()
        view.text = "할일 이름임"
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    let updateButton = {
        let view = UIButton()
        view.setTitle("수정하기", for: .normal)
        view.setImage(Design.Image.todoUpdate, for: .normal)
        
        var configuration = UIButton.Configuration.gray()
        //타이틀
        
        configuration.baseForegroundColor = Design.Color.blackFont
        // 이미지와 타이틀을 아래로 배치
        configuration.imagePlacement = NSDirectionalRectEdge.top
        configuration.imagePadding = 10
        configuration.titlePadding = -10
        configuration.buttonSize = .small
        
        view.configuration = configuration
        
        view.sizeToFit()
        return view
    }()
    
    let deleteButton = {
        let view = UIButton()
        view.setTitle("삭제하기", for: .normal)
        view.setImage(Design.Image.todoDelete, for: .normal)
        
        var configuration = UIButton.Configuration.gray()
        // 이미지와 타이틀을 아래로 배치
        configuration.baseForegroundColor = Design.Color.blackFont
        configuration.imagePlacement = NSDirectionalRectEdge.top
        configuration.imagePadding = 10
        configuration.titlePadding = -10
        configuration.buttonSize = .small
        
        view.configuration = configuration
        view.sizeToFit()
        return view
    }()
    let tomorrowButton = {
        let view = UIButton()
        view.setTitle("내일로 미루기", for: .normal)
        view.setImage(Design.Image.todoTomorrow, for: .normal)
        
        var configuration = UIButton.Configuration.plain()
        // 이미지와 타이틀을 아래로 배치
        configuration.baseForegroundColor = Design.Color.blackFont
        configuration.buttonSize = .mini
        configuration.titlePadding = -10
        configuration.imagePadding = 10
        view.configuration = configuration
        view.sizeToFit()
        return view
    }()
    
    override func setHierarchy() {
        addSubview(titleLabel)
        addSubview(updateButton)
        addSubview(deleteButton)
        addSubview(tomorrowButton)
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(30)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        updateButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(80)
        }
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-20)
            make.leading.equalTo(updateButton.snp.trailing).offset(10)
            make.width.equalTo(updateButton.snp.width)
            make.height.equalTo(80)
        }
        tomorrowButton.snp.makeConstraints { make in
            make.top.equalTo(deleteButton.snp.bottom).offset(20)
            make.leading.equalTo(updateButton.snp.leading)
            
        }
    }
    
    
    
}
