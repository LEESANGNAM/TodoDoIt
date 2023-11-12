//
//  ViewModelTypeProtocol.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/11/12.
//

import Foundation
import RxSwift

protocol ViewModelType{
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}
