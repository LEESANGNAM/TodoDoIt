//
//  TodoDetailViewController.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/11.
//

import Foundation

class TodoDetailViewcontroller: BaseViewController {
    
    let mainView = TodoDetailView()
    let viewmodel = TodoDetailViewModel()
    
    weak var delegate: ModalPresentDelegate?
    override func loadView() {
        view = mainView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewmodel.fetchTodo()
        setButtonAction()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewmodel.fetchTodo()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.disMissModal(section: .todo)
    }
    private func setButtonAction() {
        mainView.updateButton.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        mainView.deleteButton.addTarget(self, action: #selector(deleteButtonapped), for: .touchUpInside)
        mainView.tomorrowButton.addTarget(self, action: #selector(tomorrowButtonTapped), for: .touchUpInside)
    }
    
    @objc private func updateButtonTapped() {
        let vc = TodoAddViewController()
        vc.delegate = self
        vc.viewmodel.todo.value = viewmodel.getTodo()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc,animated: true)
    }
    @objc private func deleteButtonapped() {
        showAlert(text: "삭제하시겠습니까?", addButtonText: "확인") { [weak self] in
            self?.viewmodel.deleteTodo()
            self?.dismiss(animated: true)
        }
    }
    @objc private func tomorrowButtonTapped() {
        showAlert(text: "내일로 미루시겠습니까?", addButtonText: "확인") { [weak self] in
            self?.viewmodel.updateTodo()
            self?.dismiss(animated: true)
        }
    }
    
    private func bind() {
        viewmodel.todo.bind { [weak self] todo in
            guard let todo else { return }
            self?.mainView.titleLabel.text = todo.title
        }
    }
    
    
}

extension TodoDetailViewcontroller: ModalPresentDelegate {
    func sendDateToModal() -> Date {
        return viewmodel.todo.value?.createDate ?? Date()
    }
    func disMissModal(section: SectionType) {
        viewmodel.fetchTodo()
    }
}
