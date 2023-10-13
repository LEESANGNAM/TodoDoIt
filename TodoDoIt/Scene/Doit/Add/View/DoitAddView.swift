//
//  DoitAddView.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/09/28.
//

import UIKit

class DoitAddView: BaseView {
    let doitLabel = {
        let view = UILabel()
        view.text = "목표"
        return view
    }()
    let dateTitleLabel = {
        let view = UILabel()
        view.text = "기간"
        return view
    }()
    let startDateLabel = {
        let view = UILabel()
        view.text = "시작"
        return view
    }()
    let endDateLabel = {
        let view = UILabel()
        view.text = "종료"
        return view
    }()
    let completeLabel = {
        let view = UILabel()
        view.text = "횟수"
        return view
    }()
    let doitTextField = {
        let view = UITextField()
        view.placeholder = "목표를 입력해주세요"
        return view
    }()
    let startDateTextField = {
        let view = UITextField()
        view.placeholder = "00.00.00"
        return view
    }()
    let endDateTextField = {
        let view = UITextField()
        view.placeholder = "00.00.00"
        return view
    }()
    let completeTextField = {
        let view = UITextField()
        view.placeholder = "00회"
        return view
    }()
    
    override func setHierarchy() {
        addSubview(doitLabel)
        addSubview(dateTitleLabel)
        addSubview(startDateLabel)
        addSubview(endDateLabel)
        addSubview(completeLabel)
        addSubview(doitTextField)
        addSubview(startDateTextField)
        addSubview(endDateTextField)
        addSubview(completeTextField)
    }
    deinit {
        print("메인뷰 사라지")
    }
    override func setConstraints() {
        doitLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(44)
            make.height.equalTo(44)
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
        }
        dateTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(44)
            make.height.equalTo(44)
            make.top.equalTo(doitLabel.snp.bottom).offset(20)
        }
        startDateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(44)
            make.height.equalTo(44)
            make.top.equalTo(dateTitleLabel.snp.bottom).offset(20)
        }
        endDateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(44)
            make.height.equalTo(44)
            make.top.equalTo(startDateLabel.snp.bottom).offset(20)
        }
        completeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(44)
            make.height.equalTo(44)
            make.top.equalTo(endDateLabel.snp.bottom).offset(20)
        }
        
        doitTextField.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(doitLabel.snp.top)
        }
        startDateTextField.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(startDateLabel.snp.top)
        }
        endDateTextField.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(endDateLabel.snp.top)
        }
        completeTextField.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(completeLabel.snp.top)
        }
    }


}
