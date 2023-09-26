//
//  ViewController.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/09/24.
//

import UIKit
import FSCalendar
import SnapKit

class HomeViewController: UIViewController {
    private weak var fsCalendar: FSCalendar!
    
    override func viewDidLoad() {
         super.viewDidLoad()
        setupCalendar()
        setConstraint()
        
       
     }
    
    
    private func setupCalendar() {
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        view.backgroundColor = .white
        calendar.scrollDirection = .horizontal
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.appearance.headerMinimumDissolvedAlpha = 0
//        calendar.scope = .week // 주간 달력 설정
         view.addSubview(calendar)
         self.fsCalendar = calendar
        
    }
    
    private func setConstraint() {
        fsCalendar.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(200)
        }
    }
}

