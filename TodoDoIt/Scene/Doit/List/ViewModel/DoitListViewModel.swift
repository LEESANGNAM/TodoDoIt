//
//  DoitListViewModel.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/02.
//

import Foundation
import RealmSwift

class DoitListViewModel {
    let reposiroty = DoitRepository()
    var doitresult = Observer<Results<DoIt>?>(nil)
    var doitList = Observer<[DoIt]>([])
    var doitFinishList = Observer<[DoIt]>([])
    
    func fetch(){
        doitresult.value = reposiroty.fetch()
    }
    
    func fetchList(){
        if let result = doitresult.value{
            let doitArray = Array(result)
            doitList.value = []
            doitFinishList.value = []
            for doitElement in doitArray {
                if doitElement.finish {
                    doitFinishList.value.append(doitElement)
                }else {
                    doitList.value.append(doitElement)
                }
            }
            
        }
    }
    
    func getDoitList() -> [DoIt]{
        return doitList.value
    }
    func getDoitFinishList() -> [DoIt]{
        return doitFinishList.value
    }
    
}
