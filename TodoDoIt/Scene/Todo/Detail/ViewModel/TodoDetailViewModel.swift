//
//  TodoDetailViewModel.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/11.
//

import Foundation
import RealmSwift

class TodoDetailViewModel {
    let repository = TodoRepository()
    var todo = Observer<Todo?>(nil)
    var todokey = Observer<ObjectId?>(nil)
    
    
    func fetchTodo(){
        guard let id = todokey.value else { return}
        let realmTodo = repository.fetchFilterKey(id: id)
        todo.value = realmTodo
    }
    func getTodo() -> Todo? {
        return todo.value
    }
    func updateTodo() {
        guard let tododata = todo.value else { return }
        let today = tododata.createDate
        if let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today){
            repository.updateItem(value: ["_id":tododata._id,"createDate": tomorrow])
        }
    }
    
    func deleteTodo() {
        guard let tododata = todo.value else { return }
        repository.removeItem(tododata)
    }
    
}
