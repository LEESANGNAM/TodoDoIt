//
//  MemoListCollectionViewCell.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/11/05.
//

import UIKit

class MemoListCollectionViewCell: UICollectionViewCell {
    let contentLable = {
        let view = UILabel()
        view.text = "테스트테스트테스트테스트테스트테스트테스트테스트"
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: Design.Font.dateFontSize)
        view.textAlignment = .center
        view.textColor = Design.Color.whiteFont
        view.backgroundColor = Design.Color.cell
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    let dateLabel = {
        let view = UILabel()
        view.text = "2020.02.02"
        view.numberOfLines = 1
        view.font = .boldSystemFont(ofSize: Design.Font.dateFontSize)
        view.textColor = Design.Color.blackFont
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setHierarchy()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setHierarchy() {
        addSubview(contentLable)
        addSubview(dateLabel)
    }
    
    private func setConstraints() {
        contentLable.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview().inset(10)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLable.snp.bottom).offset(10)
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    func setUpData(memo: Memo){
        contentLable.text = memo.title
        dateLabel.text = memo.createDate.changeFormatString(format: "yyyy.MM.dd")
    }
    
    
}
