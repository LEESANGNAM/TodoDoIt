//
//  CircularProgressView.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/08.
//

import UIKit

class CircularProgressView: UIView, CAAnimationDelegate {
    var lineWidth: CGFloat = 10
    var circleShapeLayer: CAShapeLayer?
    var value: Double? {
        didSet {
            guard let _ = value else { return }
            setProgress(self.bounds)
        }
    }
    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath()

        bezierPath.addArc(withCenter: CGPoint(x: rect.midX, y: rect.midY), radius: rect.midX - ((lineWidth - 1) / 2), startAngle: 0, endAngle: .pi * 2, clockwise: true)

        bezierPath.lineWidth = 5
        Design.Color.progress.set()
        bezierPath.stroke()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // ✅ 지정된 특성 컬렉션(previousTraitCollection)과 현재 특성 컬렉션 간의 변경이 색상 값에 영향을 미치는지 여부를 묻는다.
                guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
        // ✅ 이전 traitCollection 의 userInterfaceStyle 와 비교.
                guard traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle else { return }
        circleShapeLayer?.fillColor =  Design.Color.background.cgColor
        circleShapeLayer?.strokeColor = Design.Color.cell.cgColor
        
    }
    func setProgress(_ rect: CGRect) {
        guard let value = self.value else {
            return
        }

        // TableView나 CollectionView에서 재생성 될때 계속 추가되는 것을 막기 위해 제거
        self.subviews.forEach { $0.removeFromSuperview() }
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        let bezierPath = UIBezierPath()

        bezierPath.addArc(withCenter: CGPoint(x: rect.midX, y: rect.midY), radius: rect.midX - ((lineWidth - 1) / 2), startAngle: -.pi / 2, endAngle: ((.pi * 2) * value) - (.pi / 2), clockwise: true)

        let shapeLayer = CAShapeLayer()

        shapeLayer.path = bezierPath.cgPath
        shapeLayer.lineCap = .round    // 프로그래스 바의 끝을 둥글게 설정

        let color: UIColor = Design.Color.cell
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = Design.Color.background.cgColor
        shapeLayer.lineWidth = lineWidth
        
        circleShapeLayer = shapeLayer
        self.layer.addSublayer(circleShapeLayer!)
        
        //애니메이션
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.5
        animation.delegate = self
        circleShapeLayer!.add(animation, forKey: animation.keyPath)
        
        

        // 프로그래스바 중심에 수치 입력을 위해 UILabel 추가
        let label = UILabel()
        label.text = "\(Int(value * 100))%"
        label.textColor = .label
        label.font = .systemFont(ofSize: Design.Font.titleFontSize, weight: .bold)

        self.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

    
    
}
