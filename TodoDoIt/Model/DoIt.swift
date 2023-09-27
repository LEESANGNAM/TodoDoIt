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
}

class DoitCompleted: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String
    @Persisted var impression: Date
    @Persisted var endDate: Date
    @Persisted var complete: Int
    @Persisted var finish: Bool = false
    @Persisted var doitComplete: List<DoitCompleted>
}
