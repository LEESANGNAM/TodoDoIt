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
        view.backgroundColor = .red
        view.layer.cornerRadius = 20
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    let dateLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: Design.Font.titleFontSize)
        view.textColor = Design.Color.whiteFont
        return view
    }()
    let yearMonthLabel = {
        let view = UILabel()
        view.textColor = Design.Color.whiteFont
        view.font = .systemFont(ofSize: Design.Font.contentFontSize)
        return view
    }()
    let countLabel = {
       let view = UILabel()
        view.font = .boldSystemFont(ofSize: Design.Font.titleFontSize)
        view.tintColor = Design.Color.blackFont
        return view
    }()
    let memoLabel = {
       let view = UILabel()
        view.textAlignment = .left
        view.font = .systemFont(ofSize: Design.Font.dateFontSize)
        view.tintColor = Design.Color.blackFont
        view.numberOfLines = 0
        return view
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = Design.Color.background
        setHierarchy()
        setConstraints()
    }
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHierarchy() {
        addSubview(completeImageView)
        addSubview(yearMonthLabel)
        addSubview(dateLabel)
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
        yearMonthLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.bottom.equalTo(completeImageView.snp.bottom).offset(-10)
            make.leading.equalTo(completeImageView.snp.leading).offset(20)
            make.trailing.lessThanOrEqualTo(completeImageView.snp.trailing)
        }
        dateLabel.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.bottom.equalTo(yearMonthLabel.snp.bottom).offset(-10)
            make.leading.equalTo(completeImageView.snp.leading).offset(20)
            make.trailing.lessThanOrEqualTo(completeImageView.snp.trailing)
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
        let filename = data.imageTitle + ".jpg"
        DispatchQueue.global().async {
            if let fileImage = FileManager.loadImageFromDocumentDirectory(fileName: filename){
                DispatchQueue.main.async {
                    let size = CGSize(width: self.completeImageView.frame.width, height: self.completeImageView.frame.height)
                    self.completeImageView.image = fileImage.downsampling(to: size)
                }
            }else {
                DispatchQueue.main.async {
                    self.completeImageView.backgroundColor = .systemGray3
                }
            }
        }
        dateLabel.text = data.createDate.changeFormatString(format: "dd일")
        yearMonthLabel.text = data.createDate.changeFormatString(format: "yyyy년MM월")
        memoLabel.text = data.impression
        countLabel.text = "\(totalcount - index)회차"
    }
    
}
