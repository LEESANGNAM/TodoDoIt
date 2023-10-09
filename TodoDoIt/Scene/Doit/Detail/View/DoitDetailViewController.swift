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
        setNavigationBar()
        setTableView()
        bind()
        DispatchQueue.main.asyncAfter(deadline: .now()){
            self.mainview.circularProgressbar.value = self.viewmodel.getDoitProgress()
        }
    }
    
    private func bind(){
        viewmodel.doit.bind {[weak self] _ in
            self?.viewmodel.fetchdoitCompleteList()
        }
    }
    
    private func setNavigationBar() {
        navigationItem.title = viewmodel.getDoitTitle()
        let menuElement = setUIAction()
        let menu = UIMenu(children: menuElement)
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"),menu: menu)
        menuButton.tintColor = .label
        navigationItem.rightBarButtonItem = menuButton
        
    }
    
    private func setUIAction() -> [UIAction] {
        let complete = UIAction(title: "완료") { _ in
            print("완료버튼")
        }
        let update = UIAction(title: "수정") { _ in
            print("수정버튼")
        }
        let remove = UIAction(title: "삭제") { _ in
            print("삭제버튼")
        }
        
        return [complete,update,remove]
    }
    
    private func setTableView() {
        mainview.completeTableView.register(DoitDetailTableViewCell.self, forCellReuseIdentifier: DoitDetailTableViewCell.identifier)
        mainview.completeTableView.dataSource = self
        mainview.completeTableView.delegate = self
    }
}


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
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "목표 완료"
    }
    
}
