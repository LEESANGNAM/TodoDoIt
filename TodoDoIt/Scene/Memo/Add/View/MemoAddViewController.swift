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
    let viewmodel = MemoAddViewModel()
    private let textViewPlaceHolder = "오늘 기억해야 할 것을 기록해보세요~~"
    override func loadView() {
        view = mainView
    }
    var selectDate = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewmodel.fetchMemo()
        setTitleDate()
        setButtonAddTarget()
        setTapGesture()
        setmemoTextView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.disMissModal(section: .memo)
    }
    
    private func bind(){
        viewmodel.memo.bind { [weak self] memo in
            self?.mainView.memoTextView.text = memo?.title
        }
    }
    
    private func setTitleDate(){
        if let date = delegate?.sendDateToModal(){
            mainView.titleDateLabel.text = date.changeFormatString(format: "yyyy년 MM월 dd일 EEEE")
            selectDate = date
        }
    }
    private func setmemoTextView(){
        if let _ = viewmodel.getMemo() {
            mainView.memoTextView.textColor = Design.Color.blackFont
        }else {
            memoTextViewPlaceHolder()
        }
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
        if let _ = viewmodel.getMemo() {
            mainView.closeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
            mainView.closeButton.setTitle("삭제", for: .normal)
            mainView.doneButton.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
            mainView.doneButton.setTitle("수정", for: .normal)
        }else {
            mainView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
            mainView.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        }
    }
    
    @objc private func removeButtonTapped(){
        viewmodel.removeMemodata()
        dismiss(animated: true)
    }
    @objc private func updateButtonTapped(){
        viewmodel.updateMemoData()
        dismiss(animated: true)
    }
    
    @objc private func closeButtonTapped(){
        dismiss(animated: true)
    }
    @objc private func doneButtonTapped(){
        viewmodel.saveMemoData(date: selectDate)
        dismiss(animated: true)
    }
}

extension MemoAddViewController: UITextViewDelegate {
    private func memoTextViewPlaceHolder(){
        mainView.memoTextView.text = textViewPlaceHolder
        mainView.memoTextView.textColor = .lightGray
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder{
            textView.text = nil
            textView.textColor = Design.Color.blackFont
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            memoTextViewPlaceHolder()
        }else {
            viewmodel.title.value = textView.text
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        viewmodel.title.value = textView.text
    }
    
}

