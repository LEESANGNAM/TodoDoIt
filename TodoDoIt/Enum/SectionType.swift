//
//  SectionType.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/02.
//

import Foundation


enum SectionType: Int, CaseIterable {
    case doit, todo, memo
    
    var title: String {
        switch self {
        case .doit:
            return "목표"
        case .todo:
            return "할일"
        case .memo:
            return "메모"
        }
    }
}


enum DoitSectionType: Int, CaseIterable {
    case doing, complete
    
    var title: String {
        switch self{
        case .doing:
            return "도전중인 목표"
        case .complete:
            return "완료한 목표"
        }
    }
    
}
