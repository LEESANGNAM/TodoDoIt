//
//  Observer.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/09/30.
//

import Foundation


class Observer<T> {
    var listner: ((T) -> Void)?
    
    var value: T {
        didSet{
            listner?(value)
        }
    }
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ clouser: @escaping (T) -> Void){
        clouser(value)
        listner = clouser
    }
    
}
