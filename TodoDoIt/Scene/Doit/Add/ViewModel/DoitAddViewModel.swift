//
//  DoitAddViewModel.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/09/30.
//

import Foundation

class DoitAddViewModel {
    let repository = DoitRepository()
    var startDate = Observer(Date())
    var endDate = Observer(Date())
    var completeCount = Observer(0)
    var completMaxCount = Observer<Int?>(nil)
    var doit = Observer<DoIt?>(nil)
    
     func fetchCompletMaxCount(){
         let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate.value, to: endDate.value)
        guard let dayCount = components.day else { return }
         completMaxCount.value = dayCount + 1
     }
    func getcompletMaxCount() -> Int {
        guard let Maxcount = completMaxCount.value else { return 0 }
        return Maxcount
    }
    func saveData(title: String) {
        let data = DoIt(title: title, startDate: startDate.value, endDate: endDate.value, complete: completeCount.value)
        repository.createItem(data)
    }
    func setDoitData() {
        guard let doit = doit.value else { return }
        startDate.value = doit.startDate
        endDate.value = doit.endDate
        completeCount.value = doit.complete
    }
    func getDoitData() -> DoIt? {
        return doit.value
    }
    func updateDate(doit: DoIt, title: String) {
        repository.updateItem(value: ["_id": doit._id,"title": title ,"endDate": endDate.value, "complete": completeCount.value])
    }
}
