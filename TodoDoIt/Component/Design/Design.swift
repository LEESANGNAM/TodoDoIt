//
//  Design.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/02.
//

import UIKit


enum Design{
    enum Font {
        static let titleFontSize: CGFloat = 18
        static let contentFontSize: CGFloat = 14
        static let dateFontSize: CGFloat = 10
        static let listButtonFontSize: CGFloat = 14
    }
    enum Color {
        static let background = UIColor(named: "background")!
        static let whiteFont = UIColor.white
        static let blackFont = UIColor.label
        static let cell = UIColor(named: "cell")!
        static let progress = UIColor(named: "progress")!
    }
    
    enum Image {
        static let todoAdd = UIImage(systemName: "arrow.up.circle.fill")!.withRenderingMode(.alwaysOriginal).withTintColor(Design.Color.cell) // 탭바에 넣었을때 원하는 ui가 안나올경우
        static let plusButton = UIImage(systemName: "plus.circle.fill")!.withRenderingMode(.alwaysOriginal).withTintColor(.systemIndigo) // 탭바에 넣었을때 원하는 ui가 안나올경우
        static let todoUpdate = UIImage(systemName: "pencil.line")!.withRenderingMode(.alwaysOriginal).withTintColor(.systemIndigo) // 탭바에 넣었을때 원하는 ui가 안나올경우
        static let todoDelete = UIImage(systemName: "trash.square.fill")!.withRenderingMode(.alwaysOriginal).withTintColor(.systemRed) // 탭바에 넣었을때 원하는 ui가 안나올경우
        static let todoTomorrow = UIImage(systemName: "arrow.uturn.right.circle.fill")!.withRenderingMode(.alwaysOriginal).withTintColor(.systemIndigo) // 탭바에 넣었을때 원하는 ui가 안나올경우
    }

}
