//
//  MemoAddViewModel.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/15.
//

import Foundation
import RealmSwift

class MemoAddViewModel {
    let repository = MemoRepository()
    var memoKey = Observer<ObjectId?>(nil)
    var memo = Observer<Memo?>(nil)
    var title = Observer("")
    
    func fetchMemo() {
        guard let memokey = memoKey.value else { return }
        memo.value = repository.fetchFilterKey(id: memokey)
    }
    
    func getMemo() -> Memo? {
        return memo.value
    }
    
    func removeMemodata() {
        guard let memo = memo.value else { return }
        repository.removeItem(memo)
    }
    
    func updateMemoData(){
        guard let memo = memo.value else { return }
        let title = title.value
        repository.updateItem(value: ["_id":memo._id,"title": title])
        
    }
    
    func saveMemoData(date:Date) {
        let title = title.value
        let memoData = Memo(title: title, date: date)
        repository.createItem(memoData)
    }
    
    
}
