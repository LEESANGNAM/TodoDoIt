//
//  DoitCompleteAddView.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/11.
//

import UIKit


class DoitCompleteAddView: BaseView {
    let titleLabel = {
        let view = UILabel()
        view.text = "여기 목표명"
        view.textAlignment = .center
        return view
    }()
    let memoTextView = {
        let view = UITextView()
        view.text = "메모"
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 10
       return view
    }()
    let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = .systemGray5
        return view
    }()
    let plusImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "plus")
        view.tintColor = .systemGray
        return view
    }()
    let saveButton = {
        let view = UIButton()
        view.setTitle("저장", for: .normal)
        view.layer.cornerRadius = 10
        view.backgroundColor = Design.Color.cell
        return view
    }()
    
    override func setHierarchy() {
        addSubview(titleLabel)
        addSubview(imageView)
        addSubview(plusImageView)
        addSubview(memoTextView)
        addSubview(saveButton)
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
        }
        imageView.snp.makeConstraints { make in
            make.height.equalTo(self.safeAreaLayoutGuide ).multipliedBy(0.35)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        plusImageView.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.centerX.equalTo(imageView.snp.centerX)
            make.centerY.equalTo(imageView.snp.centerY)
        }
        memoTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.top.equalTo(imageView.snp.bottom).offset(20)
        }
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.horizontalEdges.equalToSuperview().inset(10)
            make.top.equalTo(memoTextView.snp.bottom).offset(10)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    
    
}
