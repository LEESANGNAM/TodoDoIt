//
//  DoitDetailViewController.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/07.
//

import UIKit
import RealmSwift



class DoitDetailViewController: BaseViewController {
    
    let mainview = DoitDetailView()
    var doitcompleteList = List<DoitCompleted>()
    var doit: DoIt? {
        didSet {
            guard let doit else { return }
            doitcompleteList = doit.doitComplete
        }
    }
    
    override func loadView() {
        view = mainview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setTableView()
        DispatchQueue.main.asyncAfter(deadline: .now()){
            self.mainview.test.value = self.doit?.progress()
        }
    }
    func setNavigationBar() {
        navigationItem.title = doit?.title
    }
    
    func setTableView() {
        mainview.completeTableView.register(DoitDetailTableViewCell.self, forCellReuseIdentifier: DoitDetailTableViewCell.identifier)
        mainview.completeTableView.dataSource = self
        mainview.completeTableView.delegate = self
    }
}


extension DoitDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doitcompleteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainview.completeTableView.dequeueReusableCell(withIdentifier: DoitDetailTableViewCell.identifier, for: indexPath) as? DoitDetailTableViewCell else { return UITableViewCell()}
        let totalcount = doitcompleteList.count
        let data = doitcompleteList[totalcount - indexPath.row - 1]
        cell.setData(data: data, totalcount: totalcount, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "목표 완료"
    }
    
}
