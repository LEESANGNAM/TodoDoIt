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
            guard let memo else { return }
            self?.mainView.memoTextView.text = memo.title
            self?.viewmodel.title.value = memo.title
        }
        viewmodel.title.bind { [weak self] _ in
            self?.viewmodel.checkvaild()
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
        showAlert(text: "삭제하시겠습니까?", addButtonText: "확인") { [weak self] in
            self?.viewmodel.removeMemodata()
            self?.dismiss(animated: true)
        }
    }
    @objc private func updateButtonTapped(){
        if viewmodel.checkvaild() {
            viewmodel.updateMemoData()
        }else {
            print("아무것도 안일어남")
        }
        dismiss(animated: true)
    }
    
    @objc private func closeButtonTapped(){
        dismiss(animated: true)
    }
    @objc private func doneButtonTapped(){
        if viewmodel.checkvaild() {
            viewmodel.saveMemoData(date: selectDate)
        }else {
            print("아무것도 안일어남")
        }
        dismiss(animated: true)
    }
    
}

extension MemoAddViewController: UITextViewDelegate {
    private func memoTextViewPlaceHolder(){
        mainView.memoTextView.text = viewmodel.textViewPlaceHolder
        mainView.memoTextView.textColor = .lightGray
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == viewmodel.textViewPlaceHolder{
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

