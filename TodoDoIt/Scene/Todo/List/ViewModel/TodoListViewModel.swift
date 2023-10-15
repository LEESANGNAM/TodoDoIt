//
//  TodoListViewModel.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/06.
//
import Foundation
import RealmSwift

class TodoListViewModel {
    let todoRepository = TodoRepository()
    var todoResult = Observer<Results<Todo>?>(nil)
    var todoArray = Observer<[Todo]>([])
    
    func fetchData(date: Date){
        todoResult.value = todoRepository.fetchFilterDateSortByFinish(date: date)
    }
    func changeTodoArray(){
        if let result = todoResult.value{
            todoArray.value = Array(result)
        }
    }
    func getTodoArray() -> [Todo] {
        return todoArray.value
    }
    func updateTodo(todo: Todo,finish: Bool) {
        todoRepository.updateItem(value: ["_id":todo._id,"finish": finish])
    }
    func dateOfCountItem(date: Date) -> Int {
        return todoRepository.fetchFilterDate(date: date).count
    }
}
