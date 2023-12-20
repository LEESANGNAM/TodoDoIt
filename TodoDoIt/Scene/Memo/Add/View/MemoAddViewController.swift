//
//  MemoAddViewController.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/15.
//

import UIKit
import RxCocoa


class MemoAddViewController: BaseViewController {
    
    private let mainView = MemoAddView()
    
    weak var delegate: ModalPresentDelegate?
    let viewmodel: MemoAddViewModel
    
    init(viewmodel: MemoAddViewModel){
        self.viewmodel = viewmodel
        super.init()
    }
    
    override func loadView() {
        view = mainView
    }
    var selectDate = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitleDate()
        bind()
        setTapGesture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.disMissModal(section: .memo)
    }
    
    private func bind(){
//        print("여긴 바인드 선택날자",selectDate)
        let input = MemoAddViewModel.Input(selectDate: selectDate, viewWillAppear: self.rx.viewWillAppear.map { _ in }, addButtonTap: mainView.doneButton.rx.tap, removeButtonTap: mainView.closeButton.rx.tap, textViewTextChange: mainView.memoTextView.rx.text.orEmpty.changed)
        let output = viewmodel.transform(input: input)
                
        output.memo
            .asObservable()
            .distinctUntilChanged()
            .bind(with: self) { owner, memo in
                owner.setButtonAddTarget(memo: memo)
                owner.setMemoTextView(memo: memo)
                owner.viewmodel.title.accept(memo?.title ?? "")
            }.disposed(by: disposeBag)
        
        
        rx.viewWillAppear
            .bind(with: self) { owner, _ in
                owner.mainView.memoTextView.rx.didBeginEditing
                    .bind(with: self) { owner, _ in
                        if owner.mainView.memoTextView.text == owner.viewmodel.textViewPlaceHolder{
                            owner.mainView.memoTextView.text = nil
                            owner.mainView.memoTextView.textColor = Design.Color.blackFont
                        }
                    }.disposed(by: owner.disposeBag)
                
                owner.mainView.memoTextView.rx.didEndEditing
                    .bind(with: self) { owner, _ in
                        if owner.mainView.memoTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            owner.memoTextViewPlaceHolder()
                        }
                    }.disposed(by: owner.disposeBag)
            }.disposed(by: disposeBag)
        
    }
    private func memoTextViewPlaceHolder(){
        mainView.memoTextView.text = viewmodel.textViewPlaceHolder
        mainView.memoTextView.textColor = .lightGray
    }
    private func setTitleDate(){
        if let date = delegate?.sendDateToModal(){
            mainView.titleDateLabel.text = date.changeFormatString(format: "yyyy년 MM월 dd일 EEEE")
            selectDate = date
        }
    }
    private func setMemoTextView(memo: Memo?){
        if let memo = memo {
            mainView.memoTextView.textColor = Design.Color.blackFont
            mainView.memoTextView.text = memo.title
        }else {
            memoTextViewPlaceHolder()
        }
        mainView.memoTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    private func setTapGesture(){
        let mainViewTapgesture = UITapGestureRecognizer(target: self, action: #selector(MainViewTapgesture))
        mainView.addGestureRecognizer(mainViewTapgesture)
        
    }
    @objc private func MainViewTapgesture() {
        mainView.endEditing(true)
    }
    private func setButtonAddTarget(memo: Memo?){
        if let _ = memo {
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
            print("삭제버튼 탭")
            self?.dismiss(animated: true)
        }
    }
    @objc private func updateButtonTapped(){
        dismiss(animated: true)
    }
    
    @objc private func closeButtonTapped(){
        dismiss(animated: true)
    }
    @objc private func doneButtonTapped(){
        dismiss(animated: true)
    }
    
}

