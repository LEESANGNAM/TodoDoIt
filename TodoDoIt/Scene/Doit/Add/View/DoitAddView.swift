//
//  DoitAddView.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/09/28.
//

import UIKit

class DoitAddView: BaseView {
    lazy var doitLabel = createTitleLabel(text: "목표")
    lazy var dateTitleLabel = createTitleLabel(text: "기간")
    lazy var startDateLabel = createTitleLabel(text: "시작일")
    lazy var endDateLabel = createTitleLabel(text: "종료일")
    lazy var completeLabel = createTitleLabel(text: "도전 횟수")
    
    lazy var  doitTextField = createTextField(placeHolder: "도전할 목표를 입력해주세요")
    lazy var  startDateTextField = createTextField(placeHolder: "0000.00.00")
    lazy var  endDateTextField = createTextField(placeHolder: "0000.00.00")
    lazy var  completeTextField = createTextField(placeHolder: "00회")
    
    lazy var doitStackView = createStackView(child: [doitLabel, doitTextField])
    lazy var startDateStackView = createStackView(child: [startDateLabel, startDateTextField])
    lazy var endDateStackView = createStackView(child: [endDateLabel, endDateTextField])
    lazy var completeStackView = createStackView(child: [completeLabel, completeTextField])
    
    lazy var mainStackView = createStackView(child: [doitStackView,dateTitleLabel,startDateStackView,endDateStackView,completeStackView])
    
    private func createTitleLabel(text: String) -> UILabel {
        let view = UILabel()
        view.text = text
        return view
    }
    private func createTextField(placeHolder: String) -> UITextField {
        let view = UITextField()
        view.placeholder = placeHolder
        view.textAlignment = .right
        return view
    }
    private func createStackView(child: [UIView]) -> UIStackView {
        let view = UIStackView(arrangedSubviews: child)
        return view
    }
    private func setupStackView(){
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = 20
        
        
        doitStackView.distribution = .fillProportionally
        doitStackView.axis = .horizontal
        startDateStackView.distribution = .fillProportionally
        startDateStackView.axis = .horizontal
        endDateStackView.distribution = .fillProportionally
        endDateStackView.axis = .horizontal
        completeStackView.distribution = .fillProportionally
        completeStackView.axis = .horizontal
        
        
    }
    override func setHierarchy() {
        addSubview(mainStackView)
        setupStackView()
    }
    override func setConstraints() {
        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        dateTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        
    }


}
