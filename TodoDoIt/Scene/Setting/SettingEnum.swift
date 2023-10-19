//
//  SettingEnum.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/19.
//

import Foundation

enum SettingEnum: Int, CaseIterable {
    case data
    case opneSource
    
    
    var title : String {
        switch self {
        case .data:
            return "데이터"
        case .opneSource:
            return "오픈소스"
        }
    }
    
}

extension SettingEnum {
    enum dataEnum: Int, CaseIterable {
        case reset
        case backup
        case restore
        
        var title: String {
            switch self {
            case .reset:
                return "데이터 초기화"
            case .backup:
                return "데이터 백업"
            case .restore:
                return "데이터 복구"
            }
        }
    }
    enum openSourceEnum: Int, CaseIterable {
        case fsCalendar
        case realm
        case snapKit
        case toast
        
        var title: String {
            switch self {
            case .fsCalendar:
                return "fsCalendar"
            case .realm:
                return "realm"
            case .snapKit:
                return "snapKit"
            case .toast:
                return "toast"
            }
        }
    }
}
