//
//  TodoAddViewController.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/03.
//

import UIKit
import Toast

class TodoAddViewController: BaseViewController{
    let titleView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let titleTextField = {
        let view = UITextField()
        view.textColor = .black
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
        viewmodel.title.bind {[weak self] _ in
            self?.viewmodel.checkvaild()
        }
        viewmodel.vaild.bind { [weak self] valid in
            if valid {
                if let todo = self?.viewmodel.getTodo(){
                    self?.viewmodel.updateData()
                    self?.view.makeToast("할일이 변경되었습니다.")
                    self?.dismissModal()
                }else {
                    self?.viewmodel.saveData(date: self?.selectDate ?? Date())
                    self?.view.makeToast("할일이 저장되었습니다.",position: .center)
                }
            }
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
        if let todo = viewmodel.getTodo() {
            titleTextField.placeholder = todo.title + "에서 변경할 할일을 입력해주세요."
        }else{
            titleTextField.placeholder = "오늘의 할일을 입력해주세요."
        }
    }
    @objc func tapgestureTapped(){
        dismissModal()
    }
    private func dismissModal(){
        titleTextField.resignFirstResponder()
        dismiss(animated: true)
        delegate?.disMissModal(section: .todo)  // 닫힐때 호출
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
            view.makeToast("텍스트를 입력해주세요",position: .top)
            return
        }
        viewmodel.setTitle(text: title)
        titleTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {
            view.makeToast("텍스트를 입력해주세요",position: .top)
            return true
        }
        viewmodel.setTitle(text: text)
        titleTextField.text = ""
        return true
    }
}
