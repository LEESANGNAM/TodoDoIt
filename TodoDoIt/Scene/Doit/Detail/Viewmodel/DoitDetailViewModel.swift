//
//  DoitDetailViewModel.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/09.
//

import Foundation
import RealmSwift

class DoitDetailViewModel {
    let repository = Repository<DoIt>()
    var doit = Observer<DoIt?>(nil)
    var doitkey = Observer<ObjectId?>(nil)
    var doitcompleteList = Observer<[DoitCompleted]>([])
    
    func fetchDoit(){
        guard let id = doitkey.value else { return}
        let realmDoit = repository.fetchFilterKey(id: id)
        doit.value = realmDoit
    }
    func getDoitTitle() -> String {
        guard let doit = doit.value else { return "" }
        return doit.title
    }
    func getDoitProgress() -> Double {
        guard let doit = doit.value else { return 0.0}
        return doit.progress()
    }
    
    func fetchdoitCompleteList() {
        guard let doit = doit.value else { return }
        let doitComplete = doit.doitComplete
        doitcompleteList.value = Array(doitComplete)
    }
    func ListCount() -> Int {
        return doitcompleteList.value.count
    }
    func getListData(index: Int) -> DoitCompleted {
        return doitcompleteList.value[index]
    }
    
    
    
    
}
