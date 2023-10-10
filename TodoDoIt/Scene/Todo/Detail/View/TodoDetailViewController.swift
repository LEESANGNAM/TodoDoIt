//
//  TodoDetailViewController.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/11.
//

import Foundation

class TodoDetailViewcontroller: BaseViewController {
    
    let mainView = TodoDetailView()
    
    override func loadView() {
        view = mainView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
