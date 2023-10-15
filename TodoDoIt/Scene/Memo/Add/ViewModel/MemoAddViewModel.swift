//
//  MemoAddViewModel.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/15.
//

import Foundation

class MemoAddViewModel {
    let repository = MemoRepository()
    var memo = Observer("")
    
    func saveMemoData(date:Date) {
        let memo = memo.value
        let memoData = Memo(title: memo, date: date)
        repository.createItem(memoData)
    }
    
    
}
