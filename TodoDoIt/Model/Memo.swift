//
//  Memo.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/09/27.
//

import Foundation
import RealmSwift

class Memo: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String
    @Persisted var createDate = Date()
    @Persisted var UpdateDate: Date?
    
    convenience init(title: String) {
        self.init()
        self.title = title
    }
    
    
}

