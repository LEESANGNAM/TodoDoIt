//
//  HomeViewModel.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/02.
//

import Foundation
import RealmSwift

class HomeViewModel {
    let doitRepository = DoitRepository()
    let todoRepository = TodoRepository()
    let memoRepository = MemoRepository()
    var doitResult = Observer<Results<DoIt>?>(nil)
    var doitArray = Observer<[DoIt]>([])
    var todoResult = Observer<Results<Todo>?>(nil)
    var todoArray = Observer<[Todo]>([])
    var memoResult = Observer<Results<Memo>?>(nil)
    var memoArray = Observer<[Memo]>([])
    
    func fetchData(date: Date){
        fetchDoitData(date: date)
        fetchTodoData(date: date)
        fetchMemoData(date: date)
    }
    
    func fetchDoitData(date: Date){
        doitResult.value = doitRepository.fetchFilterContainsDate(date: date)
    }
    
    func fetchTodoData(date: Date){
        todoResult.value = todoRepository.fetchFilterDateSortByFinish(date: date)
    }
    func fetchMemoData(date: Date){
        memoResult.value = memoRepository.fetchFilterDate(date: date)
    }
    // 비어있는지 검사
    func dateOfCountItem(date: Date) -> Int{
        var count = 0
        let doitEmpty = doitRepository.fetchFilterContainsDate(date: date).isEmpty
        let todoEmpty = todoRepository.fetchFilterDate(date: date).isEmpty
        let memoEmpty =  memoRepository.fetchFilterDate(date: date).isEmpty
        if !doitEmpty {
            count += 1
        }
        if !todoEmpty {
            count += 1
        }
        if !memoEmpty {
            count += 1
        }
        return count
    }
    func changeArray(){
        changeDoitArray()
        changeMemoArray()
        changeTodoArray()
    }
    func changeDoitArray(){
        if let result = doitResult.value{
            let doitList = Array(result)
            doitArray.value = []
            for doitElement in doitList{
                if doitElement.finish{ }
                else {
                    doitArray.value.append(doitElement)
                }
            }
        }
    }
    func validDoitCount() -> Bool {
        let doitNotFinish = doitRepository.fetchFilterFinish()
        let notFinishcount =  doitNotFinish.count
        
        if notFinishcount < 5 {
            return true
        } else {
            return false
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
    
    func updateTodo(todo: Todo,finish: Bool) {
        todoRepository.updateItem(value: ["_id":todo._id,"finish": finish])
    }
}
