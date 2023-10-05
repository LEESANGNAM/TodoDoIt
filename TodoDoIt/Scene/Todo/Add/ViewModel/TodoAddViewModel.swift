//
//  TodoViewModel.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/04.
//

import Foundation
import RealmSwift

class TodoAddViewModel {
    let repository = Repository<Todo>()
    var title = Observer("")
    
    func setTitle(text: String){
        title.value = text
    }
    
    func saveData(date: Date){
        let text = title.value
        guard !text.isEmpty else {
            print("텍스트 비었음")
            return
        }
        guard !text.removeSpace().isEmpty else {
            print("텍스트 공백만 있음")
            return
        }
            let todo = Todo(title: text,createDate: date)
            repository.createItem(todo)
            print("아이템이 저장되었습니다.")
    }
}
