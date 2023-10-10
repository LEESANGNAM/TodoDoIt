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
    
    let titleTextField = {
        let view = UITextField()
        view.placeholder = "오늘의 할일을 입력해주세요.~~~"
        return view
    }()
    let doneButton = {
        let view = UIButton()
        view.setImage(Design.Image.todoAdd, for: .normal)
        return view
    }()
    
    let viewmodel = TodoAddViewModel()
    
    weak var delegate: ModalPresentDelegate?
    var selectDate = Date() // 넘어온 데이트
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        if let date = delegate?.sendDateToModal(){
            print(date)
            selectDate = date
        }
    }
    private func bind(){
        viewmodel.title.bind {_ in
            self.viewmodel.saveData(date: self.selectDate)
            self.titleTextField.text = ""
        }
    }
    override func setHierarchy() {
        bind()
        titleView.addSubview(titleTextField)
        titleView.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        view.addSubview(titleView)
        setUpTitleView()
        setUpGesture()
        setUpTitleTextfield()
    }
    func setUpTitleView(){
        titleView.roundCorners(cornerRadius: 10, maskedCorners: [.layerMinXMinYCorner,.layerMaxXMinYCorner])
    }
    func setUpGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapgestureTapped))
        view.addGestureRecognizer(tapGesture)
    }
    func setUpTitleTextfield(){
        titleTextField.becomeFirstResponder()
        titleTextField.delegate = self
    }
    @objc func tapgestureTapped(){
        titleTextField.resignFirstResponder()
        dismiss(animated: true)
        delegate?.disMissModal()  // 닫힐때 호출
    }
    override func setConstraints() {
        
        titleView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.top.bottom.equalToSuperview()
        }
        doneButton.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.leading.equalTo(titleTextField.snp.trailing)
            make.size.equalTo(40)
            
        }
    }
    
}

extension TodoAddViewController: UITextFieldDelegate {
    @objc func doneButtonTapped() {
        guard let title = titleTextField.text else {
            print("텍스트를 입력해주세요")
            return
        }
        guard !title.isEmpty else {
            print("텍스트가 비었습니다.")
            return
        }
        guard !title.removeSpace().isEmpty else {
            print(#function)
            print("텍스트 공백만 있음")
            titleTextField.text = ""
            return
        }

        viewmodel.setTitle(text: title)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {
            print("텍스트를 입력해주세요")
            return true
        }
        guard !text.isEmpty else {
            print("텍스트가 비었습니다.")
            return true
        }
        guard !text.removeSpace().isEmpty else {
            print(#function)
            print("텍스트 공백만 있음")
            textField.text = ""
            return true
        }

        viewmodel.setTitle(text: text)
        
        return true
    }
}
