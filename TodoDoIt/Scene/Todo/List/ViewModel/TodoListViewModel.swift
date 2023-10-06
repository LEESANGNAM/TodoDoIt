//
//  TodoListViewModel.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/06.
//
import Foundation
import RealmSwift

class TodoListViewModel {
    let todoRepository = Repository<Todo>()
    var todoResult = Observer<Results<Todo>?>(nil)
    var todoArray = Observer<[Todo]>([])
    
    func fetchData(date: Date){
        todoResult.value = todoRepository.fetchFilterDate(date: date)
    }
    func changeTodoArray(){
        if let result = todoResult.value{
            todoArray.value = Array(result)
        }
    }

    func getTodoArray() -> [Todo] {
        return todoArray.value
    }
}
