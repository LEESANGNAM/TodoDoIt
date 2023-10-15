//
//  MemoAddView.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/15.
//

import UIKit

class MemoAddView: BaseView {
    let titleDateLabel = {
        let view = UILabel()
        view.text = "2000년 00월 00일 0요일"
        view.textAlignment = .center
        view.font = .boldSystemFont(ofSize: Design.Font.titleFontSize)
        return view
    }()
    
    let closeButton = {
       let view = UIButton()
        view.setTitle("닫기", for: .normal)
        view.setTitleColor(Design.Color.blackFont, for: .normal)
        return view
    }()
    let doneButton = {
       let view = UIButton()
        view.setTitle("완료", for: .normal)
        view.setTitleColor(Design.Color.blackFont, for: .normal)
        return view
    }()

    let lineView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    let memoTextView = {
        let view = UITextView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 10
       return view
    }()
    override func setHierarchy() {
        addSubview(closeButton)
        addSubview(titleDateLabel)
        addSubview(doneButton)
        addSubview(lineView)
        addSubview(memoTextView)
    }
    
    override func setConstraints() {
        closeButton.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(10)
        }
        titleDateLabel.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.equalTo(closeButton.snp.trailing).offset(10)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(10)
        }
        doneButton.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.leading.equalTo(titleDateLabel.snp.trailing).offset(10)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-10)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(10)
        }
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(titleDateLabel.snp.bottom).offset(10)
        }
        memoTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.top.equalTo(lineView.snp.bottom).offset(20)
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.5)
        }
    }
    
    
    
}
