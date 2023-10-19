//
//  DoitDetailViewController.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/07.
//

import UIKit

class DoitDetailViewController: BaseViewController {
    
    let mainview = DoitDetailView()
    
    let viewmodel = DoitDetailViewModel()
    override func loadView() {
        view = mainview
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        viewmodel.fetchDoit()
        setNavigationBar()
        setTableView()
        bind()
        DispatchQueue.main.asyncAfter(deadline: .now()){ [weak self] in
            self?.mainview.circularProgressbar.value = self?.viewmodel.getDoitProgress()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewmodel.fetchDoit()
    }
    
    private func bind(){
        viewmodel.doit.bind {[weak self] doit in
            guard let doit else {
                self?.navigationController?.popViewController(animated: true)
                return
            }
            self?.viewmodel.fetchdoitCompleteList()
            self?.navigationItem.title = doit.title
            self?.mainview.circularProgressbar.value = doit.progress()
            self?.mainview.completeTableView.reloadData()
            self?.viewmodel.checkValidProgress()
            self?.viewmodel.checkValidDateCompleted(date: Date())
        }
        viewmodel.vaildProgress.bind {[weak self] bool in
            if bool {
                self?.viewmodel.updateValue(finish: !bool)
                self?.setNavigationBar()
            }else {
                self?.viewmodel.updateValue(finish: !bool)
                self?.setNavigationBar()
            }
        }
        viewmodel.validTodayCompleted.bind { [weak self] bool in
                self?.setNavigationBar()
        }
    }
    
    private func setNavigationBar() {
        let menuElement = setUIAction()
        let menu = UIMenu(children: menuElement)
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"),menu: menu)
        menuButton.tintColor = .label
        navigationItem.rightBarButtonItem = menuButton
        
    }
    
    private func setUIAction() -> [UIAction] {
        let complete = UIAction(title: "완료") {[weak self] _ in
            if let isProgress = self?.viewmodel.getValidProgress(),
               let isTodayComplete = self?.viewmodel.getValidDateCompleted(){
                if isProgress && isTodayComplete{
                    let vc = DoitCompleteAddViewController()
                    vc.viewmodel.doitKey.value = self?.viewmodel.getDoitKey()
                    vc.delegate = self
                    self?.present(vc, animated: true)
                }else if !isProgress {
                    self?.view.makeToast("달성한 목표입니다.")
                }else if !isTodayComplete {
                    self?.view.makeToast("오늘 목표를 달성했습니다.")
                }
            }
            
        }
        let update = UIAction(title: "수정") {[weak self] _ in
            let vc = DoitAddViewController()
            vc.viewmodel.doit.value = self?.viewmodel.doit.value
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        let remove = UIAction(title: "삭제") {[weak self] _ in
            self?.showAlert(text: "삭제하시겠습니까?", addButtonText: "확인") {[weak self] in
                self?.viewmodel.removeDoit()
                self?.navigationController?.popViewController(animated: true)
            }
        }
        return [complete,update,remove]
    }
    
    private func setTableView() {
        mainview.completeTableView.register(DoitDetailTableViewCell.self, forCellReuseIdentifier: DoitDetailTableViewCell.identifier)
        mainview.completeTableView.dataSource = self
        mainview.completeTableView.delegate = self
    }
}

extension DoitDetailViewController: ModalPresentDelegate {
    func sendDateToModal() -> Date {
        return Date()
    }
    
    func disMissModal(section: SectionType) {
        viewmodel.fetchDoit()
    }
    
    
}

//MARK: tableView
extension DoitDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.ListCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainview.completeTableView.dequeueReusableCell(withIdentifier: DoitDetailTableViewCell.identifier, for: indexPath) as? DoitDetailTableViewCell else { return UITableViewCell()}
        let totalcount = viewmodel.ListCount()
        let index = totalcount - indexPath.row - 1
        let data = viewmodel.getListData(index: index)
        cell.setData(data: data, totalcount: totalcount, index: indexPath.row)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "목표 달성"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let totalcount = viewmodel.ListCount()
        let index = totalcount - indexPath.row - 1
        if editingStyle == .delete {
            viewmodel.removeCompleted(index: index)
            viewmodel.fetchDoit()
            
        }
    }
}
