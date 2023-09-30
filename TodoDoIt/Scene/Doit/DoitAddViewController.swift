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
    var completeCount: Int?
    
    var list: [Int] = []
    var completeMaxCount: Int? {
        didSet {
            if let completeMaxCount{
                print("리스트 값 들어감")
                list = Array(1...completeMaxCount)
            }
        }
    }
    
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
        guard let completeCount else { return }
        let data = DoIt(title: title, startDate: startDate, endDate: endDate, complete: completeCount)
        repository.createItem(data)
        navigationController?.popViewController(animated: true)
    }
    
}

extension DoitAddViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let completeMaxCount else {
            print("아직 입력된 날짜가 없습니다.")
            return 0
        }
        
        return list.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        completeCount = list[row]
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(list[row])회"
    }
    
    
    
   private func daysBetweenDate(startDate: Date, endDate: Date) -> Int?{
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        
        return components.day
    }
    private func setupCompletePickerView(){
        let completePicker = UIPickerView()
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
        startDatePicker.preferredDatePickerStyle = .inline
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
        endDatePicker.preferredDatePickerStyle = .inline
        endDatePicker.locale = Locale(identifier: "ko-KR") // 한국 시간
        endDatePicker.timeZone = TimeZone(abbreviation: "KST") // 한국시간대
        endDatePicker .addTarget(self, action: #selector(endDateValueChanged), for: .valueChanged)
        
        let toolBar = setupTollbar(tag: 1)
        mainview.endDateTextField.inputView = endDatePicker
        mainview.endDateTextField.inputAccessoryView = toolBar
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
            startDate = nil
            mainview.startDateTextField.resignFirstResponder()
        } else if sender.tag == 1 {
            endDate = nil
            mainview.endDateTextField.resignFirstResponder()
        } else if sender.tag == 2 {
            completeCount = nil
            mainview.completeTextField.resignFirstResponder()
        }
       }
    
    @objc private func doneButtonTapped(_ sender: UIBarButtonItem) {
        // 완료 버튼을 눌렀을 때 실행되는 함수
        guard let startDate else {
            print("시작일수를 먼저 적어주세요")
            return
        }
        if sender.tag == 0 {
            mainview.startDateTextField.resignFirstResponder()
            let dateString = startDate.changeFormatString(format: "yyyy.MM.dd")
            mainview.startDateTextField.text = dateString
        } else if sender.tag == 1 {
            mainview.endDateTextField.resignFirstResponder()
            guard let endDate else {
                print("종료 먼저 적어주세요")
                return
            }
            mainview.endDateTextField.text = endDate.changeFormatString(format: "yyyy.MM.dd")
            completeMaxCount = daysBetweenDate(startDate: startDate, endDate: endDate) //종료일까지 입력하면 최대횟수 지정
        } else if sender.tag == 2 {
            mainview.completeTextField.resignFirstResponder()
            guard let completeCount else {
                print("횟수 선택해주세요")
                return
            }
            mainview.completeTextField.text = "\(completeCount)회"
        }
    }
}
