//
//  SettingViewController.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/19.
//

import UIKit

class SettingViewController: BaseViewController {
    let tableView = UITableView()
    let settingList = SettingEnum.allCases
    let dataList = SettingEnum.dataEnum.allCases
    let openSourceList = SettingEnum.openSourceEnum.allCases
    
    override func setHierarchy() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Design.Color.background
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch settingList[section] {
        case .data:
            return dataList.count
        case .opneSource:
            return openSourceList.count
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingList[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "tableViewcell")
        cell.textLabel?.font = .systemFont(ofSize: Design.Font.contentFontSize)
        cell.backgroundColor = Design.Color.background
        let section = settingList[indexPath.section]
        switch section {
        case .data:
            let data = dataList[indexPath.row]
            cell.textLabel?.text = data.title
        case .opneSource:
            let data = openSourceList[indexPath.row]
            cell.textLabel?.text = data.title
            
        }
        return cell
    }
    
}







