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
        DispatchQueue.main.asyncAfter(deadline: .now()){
            self.mainview.circularProgressbar.value = self.viewmodel.getDoitProgress()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewmodel.fetchDoit()
    }
    
    private func bind(){
        viewmodel.doit.bind {[weak self] doit in
            self?.viewmodel.fetchdoitCompleteList()
            self?.navigationItem.title = doit?.title
            self?.mainview.circularProgressbar.value = doit?.progress()
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
        let complete = UIAction(title: "완료") { _ in
            print("완료버튼")
            let vc = DoitCompleteAddViewController()
            vc.viewmodel.doitKey.value = self.viewmodel.getDoitKey()
            self.present(vc, animated: true)
        }
        let update = UIAction(title: "수정") { _ in
            let vc = DoitAddViewController()
            vc.viewmodel.doit.value = self.viewmodel.doit.value
            self.navigationController?.pushViewController(vc, animated: true)
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
