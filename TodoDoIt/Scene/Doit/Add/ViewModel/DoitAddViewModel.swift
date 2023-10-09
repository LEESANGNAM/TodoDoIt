//
//  DoitAddViewModel.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/09/30.
//

import Foundation

class DoitAddViewModel {
    let repository = Repository<DoIt>()
    var startDate = Observer(Date())
    var endDate = Observer(Date())
    var completeCount = Observer(0)
    var list = Observer<[Int]>([])
    var completMaxCount = Observer<Int?>(nil)
    var doit = Observer<DoIt?>(nil)
    
     func fetchCompletMaxCount(){
         let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate.value, to: endDate.value)
        guard let dayCount = components.day else { return }
         completMaxCount.value = dayCount
     }
    func fetchListValue(){
        guard let maxcount = completMaxCount.value else { return }
        list.value = Array(1...maxcount)
    }
    func fetchCompleteCount(index: Int){
        completeCount.value = getListValue(index: index)
    }
    func listCount() -> Int{
        return list.value.count
    }
    func getListValue(index: Int) -> Int {
        return list.value[index]
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
//        doit.endDate = endDate.value
//        doit.complete = completeCount.value
//        doit.title = title
        print("여긴 업데이트 되기 직전 Doit ID: ",doit._id)
        repository.updateItem(value: ["_id": doit._id,"title": title ,"endDate": endDate.value, "complete": completeCount.value])
//        repository.updateItem(doit)
    }
}