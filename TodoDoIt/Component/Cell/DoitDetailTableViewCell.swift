//
//  DoitDetailTableViewCell.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/08.
//

import UIKit


class DoitDetailTableViewCell: UITableViewCell {
    
    let completeImageView = {
       let view = UIImageView()
        view.image = UIImage(systemName: "star.fill")
        view.backgroundColor = .red
        view.layer.cornerRadius = 30
        view.contentMode = .scaleToFill
        return view
    }()
    
    let countLabel = {
       let view = UILabel()
        view.text = "00회차"
        return view
    }()
    let memoLabel = {
       let view = UILabel()
        view.text = "메모메모메모메모메모메모메모메모메모메모메모메모메모메모메모메모메모메모메모메"
        view.textAlignment = .left
        view.numberOfLines = 0
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setHierarchy()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHierarchy() {
        addSubview(completeImageView)
        addSubview(countLabel)
        addSubview(memoLabel)
    }
    
    func setConstraints(){
        completeImageView.snp.makeConstraints { make in
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.verticalEdges.equalTo(self.safeAreaLayoutGuide).inset(10)
            make.width.equalTo(self.snp.width).multipliedBy(0.4)
            make.height.equalTo(completeImageView.snp.width)
        }
        countLabel.snp.makeConstraints { make in
            make.leading.equalTo(completeImageView.snp.trailing).offset(10)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(self.safeAreaLayoutGuide)
        }
        memoLabel.snp.makeConstraints { make in
            make.leading.equalTo(completeImageView.snp.trailing).offset(10)
            make.top.equalTo(countLabel.snp.bottom).offset(10)
            make.trailing.equalTo(self.safeAreaLayoutGuide).offset(-10)
            make.bottom.lessThanOrEqualTo(self.safeAreaLayoutGuide).offset(-10)
        }
    }
    
    func setData(data: DoitCompleted, totalcount: Int, index: Int){
        memoLabel.text = data.impression
        countLabel.text = "\(totalcount - index)회차"
    }
    
}
