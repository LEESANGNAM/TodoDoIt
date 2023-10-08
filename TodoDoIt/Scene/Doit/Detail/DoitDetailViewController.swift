//
//  DoitDetailViewController.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/07.
//

import UIKit



class DoitDetailViewController: BaseViewController {
    
    let mainview = DoitDetailView()
    
    override func loadView() {
        view = mainview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        DispatchQueue.main.asyncAfter(deadline: .now()){
            self.mainview.test.value = 0.58
        }
        
        
    }
    
    func setTableView() {
        mainview.completeTableView.register(DoitDetailTableViewCell.self, forCellReuseIdentifier: DoitDetailTableViewCell.identifier)
        mainview.completeTableView.dataSource = self
        mainview.completeTableView.delegate = self
    }
}


extension DoitDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainview.completeTableView.dequeueReusableCell(withIdentifier: DoitDetailTableViewCell.identifier, for: indexPath) as? DoitDetailTableViewCell else { return UITableViewCell()}
        cell.completeImageView.layer.cornerRadius = 10
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "목표 완료"
    }
    
}
