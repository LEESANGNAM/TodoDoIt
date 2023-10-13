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
    
    var dateString: String {
        let startDate = startDate.changeFormatString(format: "yyyy.MM.dd")
        let endDate = endDate.changeFormatString(format: "yyyy.MM.dd")
        return "기간: \(startDate) ~ \(endDate)"
    }
    
    func progress() -> Double {
        let completeCount = doitComplete.count
        let count = Double(completeCount)
        let totalCount = Double(complete)
        let totalprogress = count / totalCount
        
        return totalprogress
    }
    
}

class DoitCompleted: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var impression: String
    @Persisted var imageTitle: String
    @Persisted var createDate =  Date()
    @Persisted var updateDate: Date?
    
    convenience init(impression: String) {
        self.init()
        self.impression = impression
        self.imageTitle = "\(_id)"
    }
}
