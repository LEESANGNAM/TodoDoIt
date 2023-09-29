//
//  DoitAddViewController.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/09/27.
//

import UIKit

class DoitAddViewController: BaseViewController {
    
    var startDate: Date? {
        didSet {
            print("여긴 시작일 이에요")
            print("startDate : ",startDate)
            print("endDate : ",endDate)
            print("------------------")
        }
    }
    var endDate: Date?  {
        didSet {
            print("여긴 종료일 이에요")
            print("startDate : ",startDate)
            print("endDate : ",endDate)
            print("------------------")
        }
    }
    var completeCount: Int = 0
    let mainview = DoitAddView()
    let repository = Repository()
    override func loadView() {
        view = mainview
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupPickerView()
        setupNavigationBar()
    }
    
    private func setupNavigationBar(){
        navigationItem.title = "추가하기"
        let savebutton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = savebutton
    }
    @objc  private func saveButtonTapped(){
        guard let title = mainview.doitTextField.text else { return }
        guard let startDate else { return }
        guard let endDate else { return }
        let data = DoIt(title: title, startDate: startDate, endDate: endDate, complete: 20)
        repository.createItem(data)
        navigationController?.popViewController(animated: true)
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
        startDate = sender.date
    }
    
    @objc private func endDateValueChanged(_ sender: UIDatePicker){
        endDate = sender.date
    }
    
    
    private func setupStartDatePickerView(){
        let startDatePicker = UIDatePicker()
        startDatePicker.datePickerMode = .date
        startDatePicker.date = Date() // 오늘값 넣어놓기
        startDatePicker.minimumDate = Date()
        startDatePicker.preferredDatePickerStyle = .wheels
        startDatePicker.locale = Locale(identifier: "ko-KR") // 한국 시간
        startDatePicker.timeZone = TimeZone(abbreviation: "KST") // 한국시간대
        startDatePicker.addTarget(self, action: #selector(startDateValueChanged), for: .valueChanged)
        
        
        let toolBar = setupTollbar(tag: 0)
        
        mainview.startDateTextField.inputView = startDatePicker
        mainview.startDateTextField.inputAccessoryView = toolBar
    }
    private func setupEndDatePickerView(){
        let endDatePicker = UIDatePicker()
        endDatePicker.datePickerMode = .date
        endDatePicker.date = Date() // 오늘값 넣어놓기
        endDatePicker.minimumDate = Date()
        endDatePicker.preferredDatePickerStyle = .wheels
        endDatePicker.locale = Locale(identifier: "ko-KR") // 한국 시간
        endDatePicker.timeZone = TimeZone(abbreviation: "KST") // 한국시간대
        endDatePicker .addTarget(self, action: #selector(endDateValueChanged), for: .valueChanged)
        
        let toolBar = setupTollbar(tag: 1)
        mainview.endDateTextField.inputView = endDatePicker
        mainview.endDateTextField.inputAccessoryView = toolBar
    }
    private func setupCompletePickerView(){
        let completePicker = UIPickerView()
        let toolBar = setupTollbar(tag: 2)
        mainview.completeTextField.inputView = completePicker
        mainview.completeTextField.inputAccessoryView = toolBar
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
            mainview.startDateTextField.resignFirstResponder()
        } else if sender.tag == 1 {
            mainview.endDateTextField.resignFirstResponder()
        } else if sender.tag == 2 {
            mainview.completeTextField.resignFirstResponder()
        }
       }
    
    @objc private func doneButtonTapped(_ sender: UIBarButtonItem) {
        // 완료 버튼을 눌렀을 때 실행되는 함수
        if sender.tag == 0 {
            mainview.startDateTextField.resignFirstResponder()
            if let startDate {
                let dateString = startDate.changeFormatString(format: "yyyy.MM.dd")
                mainview.startDateTextField.text = dateString
            }
        } else if sender.tag == 1 {
            mainview.endDateTextField.resignFirstResponder()
            if let endDate{
                mainview.endDateTextField.text = endDate.changeFormatString(format: "yyyy.MM.dd")
            }
        } else if sender.tag == 2 {
            mainview.completeTextField.resignFirstResponder()
        }
    }
}
