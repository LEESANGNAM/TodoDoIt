//
//  Todo.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/09/27.
//

import Foundation
import RealmSwift

class Todo: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String
    @Persisted var finish: Bool = false
    @Persisted var createDate: Date
    @Persisted var UpdateDate: Date?
    
    convenience init(title: String, createDate: Date) {
        self.init()
        self.title = title
        self.createDate = createDate
    }
}
