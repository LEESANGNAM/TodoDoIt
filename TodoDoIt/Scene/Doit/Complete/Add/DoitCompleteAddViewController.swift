//
//  DoitCompleteAddViewController.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/11.
//

import UIKit


class DoitCompleteAddViewController: BaseViewController {
    
    let mainView = DoitCompleteAddView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}
