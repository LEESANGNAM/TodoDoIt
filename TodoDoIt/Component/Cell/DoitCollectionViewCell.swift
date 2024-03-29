//
//  DotiCollectionViewCell.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/01.
//

import UIKit

class DoitCollectionViewCell: BaseCollectionViewCell {
    var titleLabel = {
        let view = UILabel()
        view.text = "목표 : 머ㅏㄴ옴너ㅏ옹ㄴㅁ오ㅓㅁㄴㅇ"
        view.font = .boldSystemFont(ofSize: Design.Font.titleFontSize)
        view.textColor = Design.Color.whiteFont
        return view
    }()
    var dateLabel = {
        let view = UILabel()
        view.text = "기간: 2023.09.10 ~ 2023.10.23"
        view.font = .systemFont(ofSize: Design.Font.dateFontSize)
        view.textColor = Design.Color.whiteFont
        return view
    }()
    var progressView = {
       let view = UIProgressView()
        view.progress = 0
        view.progressTintColor = Design.Color.whiteFont
        view.trackTintColor = Design.Color.progress
        
        return view
    }()
    var progressLabel = {
        let view = UILabel()
        view.text = "50%"
        view.font = .boldSystemFont(ofSize: Design.Font.contentFontSize)
        view.textColor = Design.Color.whiteFont
        return view
    }()
    
    override func setHierarchy() {
        addSubview(titleLabel)
        addSubview(dateLabel)
        addSubview(progressView)
        addSubview(progressLabel)
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
//            make.height.equalTo(30)
            make.top.equalToSuperview().offset(10)
        }
        dateLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
//            make.height.equalTo(30)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        progressView.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).offset(20)
            make.height.equalTo(4)
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
        }
        progressLabel.snp.makeConstraints { make in
            make.leading.equalTo(progressView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-5)
            make.height.equalTo(20)
            make.top.equalTo(dateLabel.snp.bottom)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-5)
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
       progressView.setProgress(0, animated: true)
    }
    func setupData(doit: DoIt){
        layoutIfNeeded()
        let progress = doit.progress()
        let title = doit.title
        let date = doit.dateString
        
        titleLabel.text = title
        dateLabel.text = date
        DispatchQueue.main.async {
            self.progressView.setProgress(Float(progress), animated: true)
        }
        progressLabel.text = "\(Int(progress * 100))%"
    }
}
