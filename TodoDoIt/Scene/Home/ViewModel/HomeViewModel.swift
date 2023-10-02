//
//  HomeViewModel.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/02.
//

import Foundation
import RealmSwift

class HomeViewModel {
    let doitRepository = Repository<DoIt>()
    let todoRepository = Repository<Todo>()
    let memoRepository = Repository<Memo>()
    var doitResult = Observer<Results<DoIt>?>(nil)
    var doitArray = Observer<[DoIt]>([])
    var todoResult = Observer<Results<Todo>?>(nil)
    var todoArray = Observer<[Todo]>([])
    var memoResult = Observer<Results<Memo>?>(nil)
    var memoArray = Observer<[Memo]>([])
    
    func fetchData(){
        fetchDoitData()
        fetchTodoData()
        fetchMemoData()
    }
    
    func fetchDoitData(){
        doitResult.value = doitRepository.fetch()
    }
    
    func fetchTodoData(){
        todoResult.value = todoRepository.fetch()
    }
    func fetchMemoData(){
        memoResult.value = memoRepository.fetch()
    }
    
    func changeDoitArray(){
        if let result = doitResult.value{
            doitArray.value = Array(result)
        }
    }
    func changeTodoArray(){
        if let result = todoResult.value{
            todoArray.value = Array(result)
        }
    }
    func changeMemoArray(){
        if let result = memoResult.value{
            memoArray.value = Array(result)
        }
    }

    func getDoitArray() -> [DoIt] {
        return doitArray.value
    }
    func getTodoArray() -> [Todo] {
        return todoArray.value
    }
    func getMemoArray() -> [Memo] {
        return memoArray.value
    }
}
