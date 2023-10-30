//
//  DoitAddViewController.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/09/27.
//

import UIKit

class DoitAddViewController: BaseViewController {
    let mainview = DoitAddView()
    let completePicker = UIPickerView()
    let viewmodel = DoitAddViewModel()
    
    override func loadView() {
        view = mainview
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Design.Color.background
        bind()
        setupPickerView()
        setupNavigationBar()
        setUpTapGesture()
        setDelegate()
    }
    func bind(){
        viewmodel.startDate.bind { [weak self] data in
            let dateString = data.changeFormatString(format: "yyyy.MM.dd")
            self?.mainview.startDateTextField.text = dateString
        }
        viewmodel.doit.bind {[weak self] doit in
            guard let doit else { return }
            self?.mainview.doitTextField.text = doit.title
            self?.mainview.endDateTextField.text = doit.endDate.changeFormatString(format: "yyyy.MM.dd")
            self?.mainview.completeTextField.text = "\(doit.complete)"
            self?.viewmodel.setDoitData()
            
        }
        viewmodel.endDate.bind {[weak self] data in
            let dateString = data.changeFormatString(format: "yyyy.MM.dd")
            self?.mainview.endDateTextField.text = dateString
            self?.viewmodel.fetchCompletMaxCount()
        }
    }
    private func setUpTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapgestureTapped))
        view.addGestureRecognizer(tapGesture)
    }
    @objc private func tapgestureTapped(){
        view.endEditing(true)
    }
    private func setupNavigationBar(){
        if let doit = viewmodel.getDoitData(){
            self.navigationItem.title = "수정하기"
            let updateButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(updateButtonTapped))
            self.navigationItem.rightBarButtonItem = updateButton
        }else {
            navigationItem.title = "추가하기"
            let savebutton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
            navigationItem.rightBarButtonItem = savebutton
        }
    }
    @objc  private func saveButtonTapped(){
        guard let title = mainview.doitTextField.text else { return }
        view.endEditing(true)
        if title.isEmpty {
            view.makeToast("목표명을 입력해주세요")
            return
        }else if title.removeSpace().isEmpty {
            view.makeToast("빈칸만 있습니다. 목표명을 입력해주세요")
            mainview.doitTextField.text = ""
            return
        }else if viewmodel.completeCount.value == 0{
            view.makeToast("도전횟수를 입력해주세요")
            return
        }else{
            viewmodel.saveData(title: title)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc  private func updateButtonTapped(){
        guard let title = mainview.doitTextField.text else { return }
        view.endEditing(true)
        guard let doit = viewmodel.getDoitData() else { return }
        if title.isEmpty {
            view.makeToast("목표명을 입력해주세요")
            return
        } else if title.removeSpace().isEmpty {
            view.makeToast("빈칸만 있습니다. 목표명을 입력해주세요")
            mainview.doitTextField.text = ""
            return
        } else if viewmodel.completeCount.value < doit.doitComplete.count{
            view.makeToast("현재 완료한 횟수보다 적습니다.")
            return
        }else{
            viewmodel.updateDate(doit: doit,title: title)
        }
        navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - textfield delegate
extension DoitAddViewController: UITextFieldDelegate {
    private func setDelegate(){
        mainview.completeTextField.delegate = self
        mainview.completeTextField.keyboardType = .numberPad
        mainview.completeTextField.addTarget(self, action: #selector(completeTextFieldValueChanged), for: .editingChanged)
        
        mainview.startDateTextField.delegate = self
        mainview.startDateTextField.tag = 1
        
        mainview.endDateTextField.delegate = self
        mainview.endDateTextField.tag = 1
    }
    @objc func completeTextFieldValueChanged(_ sender: UITextField){
        guard let text = sender.text else { return }
        if let intText = Int(text){
            viewmodel.completeCount.value = intText
        }else {
            viewmodel.completeCount.value = 0
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 달력 텍스트필드 입력막기
        if textField.tag == 1{
            return false
        }
        let maxCount = viewmodel.getcompletMaxCount()
        // backspace 허용
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        // 숫자만 입력 가능
        guard Int(string) != nil else {
            view.makeToast("숫자만 입력 가능합니다.")
            return false
        }
        if let text = textField.text, let inputInt = Int(text + string) {
                if inputInt >= maxCount {
                    viewmodel.completeCount.value = maxCount
                    mainview.completeTextField.text = "\(maxCount)"
                    view.makeToast("최대횟수 \(maxCount) 회 입니다.")
                    textField.resignFirstResponder()
                    return false
                } else {
                    viewmodel.completeCount.value = inputInt
                    return true
                }
            } else {
                return false
            }
    }
    
}

//}
//MARK: - datePicker,ToolBar
extension DoitAddViewController {
    private func setupPickerView(){
        setupStartDatePickerView()
        setupEndDatePickerView()
    }
    
    @objc private func startDateValueChanged(_ sender: UIDatePicker){
        viewmodel.startDate.value = sender.date
    }
    
    @objc private func endDateValueChanged(_ sender: UIDatePicker){
        viewmodel.endDate.value = sender.date
    }
    
    private func setupStartDatePickerView(){
        let startDatePicker = createDatePickerView()
        startDatePicker.isEnabled = false // 시작날짜는 오늘로 고정
        startDatePicker.addTarget(self, action: #selector(startDateValueChanged), for: .valueChanged)
        
        mainview.startDateTextField.inputView = startDatePicker
    }
    private func setupEndDatePickerView(){
        let endDatePicker = createDatePickerView()
        endDatePicker .addTarget(self, action: #selector(endDateValueChanged), for: .valueChanged)
        mainview.endDateTextField.inputView = endDatePicker
    }
    
    private func createDatePickerView() -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.date = Date() // 오늘값 넣어놓기
        picker.minimumDate = Date()
        picker.preferredDatePickerStyle = .inline
        picker.locale = Locale(identifier: "ko-KR") // 한국 시간
        picker.timeZone = TimeZone(abbreviation: "KST") // 한국시간대
        return picker
    }
    
}
