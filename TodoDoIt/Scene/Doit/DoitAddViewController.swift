//
//  DoitAddViewController.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/09/27.
//

import UIKit

class DoitAddViewController: BaseViewController {
    let mainview = DoitAddView()
    override func loadView() {
        view = mainview
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
