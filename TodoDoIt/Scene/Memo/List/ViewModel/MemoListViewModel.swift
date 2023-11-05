//
//  MemoListViewModel.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/11/05.
//

import Foundation
import RealmSwift

class MemoListViewModel {
    let repository = MemoRepository()
    var memoResult = Observer<Results<Memo>?>(nil)
    var memoArray = Observer<[Memo]>([])
    
    func fetchData(){
        memoResult.value = repository.fetch()
    }
    func changeMemoArray(){
        if let result = memoResult.value{
            memoArray.value = Array(result)
        }
    }
    func getMemoArray() -> [Memo] {
        return memoArray.value
    }
    
}
