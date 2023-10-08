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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mainview.test.value = 0.47
    }
    
    
}
