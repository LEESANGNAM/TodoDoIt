//
//  ModalPresentDelegate.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/06.
//

import Foundation

protocol ModalPresentDelegate: AnyObject {
    func sendDateToModal() -> Date
    func disMissModal(section: SectionType)
}
