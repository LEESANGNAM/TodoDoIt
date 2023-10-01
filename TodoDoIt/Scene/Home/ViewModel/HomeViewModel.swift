//
//  HomeViewModel.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/02.
//

import Foundation
import RealmSwift

class HomeViewModel {
    let repository = Repository<DoIt>()
    var result = Observer<Results<DoIt>?>(nil)
    var doItArray = Observer<[DoIt]>([])
    
    func fetchData(){
        result.value = repository.fetch()
    }
    
    func getDoitArray() -> [DoIt] {
        return doItArray.value
    }
    func changeArray(){
        if let result = result.value{
            doItArray.value = Array(result)
        }
    }
    
}
