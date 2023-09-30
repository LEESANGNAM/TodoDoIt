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
        view.backgroundColor = .white
        bind()
        setupPickerView()
        setupNavigationBar()
    }
    func bind(){
        viewmodel.startDate.bind { [weak self] data in
            let dateString = data.changeFormatString(format: "yyyy.MM.dd")
            self?.mainview.startDateTextField.text = dateString
        }
        viewmodel.endDate.bind {
            print("종료일 바꾸는중",$0) // 시작일과 비교해서 경고창 띄우기
        }
        viewmodel.completMaxCount.bind {[weak self] _ in
            self?.viewmodel.fetchListValue()
        }
    }
    
    private func setupNavigationBar(){
        navigationItem.title = "추가하기"
        let savebutton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = savebutton
    }
    @objc  private func saveButtonTapped(){
        guard let title = mainview.doitTextField.text else { return }
        viewmodel.saveData(title: title)
        navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - UIPickerView
extension DoitAddViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewmodel.listCount()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row,"이건 인덱스번호임 몇번까지있나.보자 ")
        print(viewmodel.listCount(),"이건 리스트 길이임 몇번까지인지보다")
        print("ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ")
        viewmodel.fetchCompleteCount(index: row)
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let data = viewmodel.getListValue(index: row)
        return "\(data)회"
    }
    private func setupCompletePickerView(){
        let toolBar = setupTollbar(tag: 2)
        completePicker.delegate = self
        completePicker.dataSource = self
        mainview.completeTextField.inputView = completePicker
        mainview.completeTextField.inputAccessoryView = toolBar
    }
    
}
//MARK: - datePicker,ToolBar
extension DoitAddViewController {
    private func setupPickerView(){
        setupStartDatePickerView()
        setupEndDatePickerView()
        setupCompletePickerView()
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
        
        let toolBar = setupTollbar(tag: 0)
        
        mainview.startDateTextField.inputView = startDatePicker
        mainview.startDateTextField.inputAccessoryView = toolBar
    }
    private func setupEndDatePickerView(){
        let endDatePicker = createDatePickerView()
        endDatePicker .addTarget(self, action: #selector(endDateValueChanged), for: .valueChanged)
        
        let toolBar = setupTollbar(tag: 1)
        
        mainview.endDateTextField.inputView = endDatePicker
        mainview.endDateTextField.inputAccessoryView = toolBar
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
    
    private func setupTollbar(tag: Int) -> UIToolbar{
        let toolbar = UIToolbar()
        toolbar.sizeToFit() // 사이즈 맞추기
        
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonTapped))
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneButtonTapped))
        cancelButton.tag = tag
        doneButton.tag = tag
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([cancelButton,space,doneButton], animated: false)
        return toolbar
    }
    
    @objc private func cancelButtonTapped(_ sender: UIBarButtonItem) {
           // 취소 버튼을 눌렀을 때 실행되는 함수
        if sender.tag == 0 {
            mainview.startDateTextField.text = ""
            mainview.startDateTextField.resignFirstResponder()
        } else if sender.tag == 1 {
            mainview.endDateTextField.text = ""
            mainview.endDateTextField.resignFirstResponder()
        } else if sender.tag == 2 {
            mainview.completeTextField.text = ""
            mainview.completeTextField.resignFirstResponder()
        }
       }
    
    @objc private func doneButtonTapped(_ sender: UIBarButtonItem) {
        // 완료 버튼을 눌렀을 때 실행되는 함수
        if sender.tag == 0 {
            mainview.startDateTextField.resignFirstResponder()
            let dateString = viewmodel.startDate.value.changeFormatString(format: "yyyy.MM.dd")
            mainview.startDateTextField.text = dateString
        } else if sender.tag == 1 {
            mainview.endDateTextField.resignFirstResponder()
            mainview.endDateTextField.text = viewmodel.endDate.value.changeFormatString(format: "yyyy.MM.dd")
            viewmodel.fetchCompletMaxCount()
        } else if sender.tag == 2 {
            mainview.completeTextField.resignFirstResponder()
            mainview.completeTextField.text = "\(viewmodel.completeCount.value)회"
        }
    }
}
