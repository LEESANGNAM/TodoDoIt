//
//  MemoAddViewController.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/15.
//

import UIKit


class MemoAddViewController: BaseViewController {
    
    private let mainView = MemoAddView()
    
    weak var delegate: ModalPresentDelegate?
    private let viewmodel = MemoAddViewModel()
    private let textViewPlaceHolder = "오늘 기억해야 할 것을 기록해보세요~~"
    override func loadView() {
        view = mainView
    }
    var selectDate = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitleDate()
        setButtonAddTarget()
        setTapGesture()
        setmemoTextView()
        
    }
    private func setTitleDate(){
        if let date = delegate?.sendDateToModal(){
            mainView.titleDateLabel.text = date.changeFormatString(format: "yyyy년 MM월 dd일 EEEE")
            selectDate = date
        }
    }
    private func setmemoTextView(){
        mainView.memoTextView.text = textViewPlaceHolder
        mainView.memoTextView.textColor = .lightGray
        mainView.memoTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        mainView.memoTextView.delegate = self
    }
    private func setTapGesture(){
        let mainViewTapgesture = UITapGestureRecognizer(target: self, action: #selector(MainViewTapgesture))
        mainView.addGestureRecognizer(mainViewTapgesture)
        
    }
    @objc private func MainViewTapgesture() {
        mainView.endEditing(true)
    }
    private func setButtonAddTarget(){
        mainView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        mainView.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    @objc private func closeButtonTapped(){
        dismiss(animated: true)
    }
    
    @objc private func doneButtonTapped(){
        viewmodel.saveMemoData(date: selectDate)
        delegate?.disMissModal()
        dismiss(animated: true)
    }
}



extension MemoAddViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder{
            textView.text = nil
            textView.textColor = Design.Color.blackFont
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        }else {
            viewmodel.memo.value = textView.text
        }
    }
    
}

