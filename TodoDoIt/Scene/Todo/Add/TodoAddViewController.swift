//
//  TodoAddViewController.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/03.
//

import UIKit

class TodoAddViewController: BaseViewController{
    let titleView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    let titleLabel = {
        let view = UILabel()
        view.text = "할일 : "
        view.font = .boldSystemFont(ofSize: Design.titleFontSize)
        return view
    }()
    let titleTextField = {
        let view = UITextField()
        view.placeholder = "오늘의 할일을 입력해주세요.~~~"
        return view
    }()
    let doneButton = {
        let view = UIButton()
        view.setTitle("완료", for: .normal)
        view.backgroundColor = .systemBlue
        view.tintColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
    }
    
    override func setHierarchy() {
        titleView.addSubview(titleLabel)
        titleView.addSubview(titleTextField)
        titleView.addSubview(doneButton)
        view.addSubview(titleView)
    }
    override func setConstraints() {
        
        titleView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(50)
        }
        titleTextField.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(20)
            make.top.bottom.equalToSuperview()
        }
        doneButton.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.leading.equalTo(titleTextField.snp.trailing).offset(20)
            
        }
    }
    
}
