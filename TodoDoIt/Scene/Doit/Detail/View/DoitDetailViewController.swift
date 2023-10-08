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
    
    func bind(){
        viewmodel.doit.bind {[weak self] _ in
            self?.viewmodel.fetchdoitCompleteList()
        }
    }
    
    func setNavigationBar() {
        navigationItem.title = viewmodel.getDoitTitle()
    }
    
    func setTableView() {
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
