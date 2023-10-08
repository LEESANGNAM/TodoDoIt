//
//  DoitDetailView.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/08.
//

import UIKit



class DoitDetailView: BaseView {
    var test = CircularProgressView()
    
    var completeTableView = {
        let view = UITableView()
        return view
    }()
    
    override func setHierarchy() {
        super.setHierarchy()
        addSubview(test)
        test.backgroundColor = .systemBackground
        addSubview(completeTableView)
    }
    
    override func setConstraints() {
        test.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.size.equalTo(150)
        }
        completeTableView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(test.snp.bottom).offset(10)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
}
