//
//  DoIt.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/09/27.
//

import Foundation
import RealmSwift

class DoIt: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String
    @Persisted var startDate: Date
    @Persisted var endDate: Date
    @Persisted var complete: Int
    @Persisted var finish: Bool = false
    @Persisted var doitComplete: List<DoitCompleted>
    
    convenience init(title: String, startDate: Date, endDate: Date, complete: Int) {
        self.init()
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.complete = complete
    }
    
    
}

class DoitCompleted: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String
    @Persisted var impression: String
    @Persisted var imageTitle: String
    @Persisted var createDate =  Date()
    @Persisted var updateDate: Date?
    
    convenience init(title: String, impression: String) {
        self.init()
        self.title = title + "\(_id)"
        self.impression = impression
        self.imageTitle = self.title + "\(createDate)"
    }
}
