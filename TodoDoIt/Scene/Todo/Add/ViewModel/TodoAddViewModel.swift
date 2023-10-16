//
//  TodoViewModel.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/04.
//

import Foundation
import RealmSwift

class TodoAddViewModel {

    let repository = TodoRepository()
    var todo = Observer<Todo?>(nil)
    var title = Observer("")
    var vaild = Observer(false)
    
    func setTitle(text: String){
        title.value = text
    }
    
    func getTodo() -> Todo? {
        return todo.value
    }
    
    func updateData(){
        guard let todo = todo.value else { return }
        let id = todo._id
        let title = title.value
        repository.updateItem(value: ["_id":todo._id,"title": title])
    }
    func checkvaild(){
        let text = title.value
        if text.isEmpty{
            print("텍스트 비었음")
        } else if  text.removeSpace().isEmpty {
            print("텍스트 공백만 있음")
        }else {
            vaild.value = true
        }
    }
    func saveData(date: Date){
        let text = title.value
        let todo = Todo(title: text,createDate: date)
        repository.createItem(todo)
    }
}
