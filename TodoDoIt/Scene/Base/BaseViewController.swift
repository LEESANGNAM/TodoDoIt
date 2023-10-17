//
//  BaseViewController.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/09/27.
//

import UIKit

class BaseViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Design.Color.background
        setHierarchy()
        setConstraints()
        // Do any additional setup after loading the view.
    }
    
    
    func setHierarchy(){ }
    func setConstraints(){ }
    
    func showAlert(text: String, addButtonText: String? = nil, Action: (() -> Void)? = nil) {
            let alert = UIAlertController(title: "경고!", message: text, preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(cancel)
            
            if let buttonText = addButtonText {
                let customAction = UIAlertAction(title: buttonText, style: .destructive) { _ in
                    Action?()
                }
                alert.addAction(customAction)
            }
            present(alert, animated: true)
        }
}
