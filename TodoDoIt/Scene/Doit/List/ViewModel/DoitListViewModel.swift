//
//  DoitListViewModel.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/02.
//

import Foundation
import RealmSwift

class DoitListViewModel {
    let reposiroty = Repository<DoIt>()
    var doitresult = Observer<Results<DoIt>?>(nil)
    var doitList = Observer<[DoIt]>([])
    
    func fetch(){
        doitresult.value = reposiroty.fetch()
    }
    
    func fetchList(){
        if let result = doitresult.value{
            doitList.value = Array(result)
        }
    }
    
    func getDoitList() -> [DoIt]{
        return doitList.value
    }
    
}
