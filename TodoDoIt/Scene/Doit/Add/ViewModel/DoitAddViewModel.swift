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
    
}
