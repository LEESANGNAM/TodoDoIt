//
//  DoitCompleteAddViewModel.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/13.
//

import Foundation
import RealmSwift

class DoitCompleteAddViewModel {
    let repository = DoitRepository()
    var doitKey = Observer<ObjectId?>(nil)
   
    func updateValue(complete: DoitCompleted){
        guard let key = doitKey.value else { return }
        repository.appendCompletedItem(doItId: key, completedItem: complete)
    }
}
