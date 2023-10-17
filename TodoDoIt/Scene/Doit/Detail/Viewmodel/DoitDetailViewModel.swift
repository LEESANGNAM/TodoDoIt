//
//  DoitDetailViewModel.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/09.
//

import Foundation
import RealmSwift

class DoitDetailViewModel {
    let repository = DoitRepository()
    var doit = Observer<DoIt?>(nil)
    var doitkey = Observer<ObjectId?>(nil)
    var doitcompleteList = Observer<[DoitCompleted]>([])
    var vaildProgress = Observer(true)
    var validTodayCompleted = Observer(true)
    
    func updateValue(){
        guard let doitData = doit.value else { return }
        repository.updateItem(value: ["_id": doitData._id, "finish": true])
    }
    
    func fetchDoit(){
        guard let id = doitkey.value else { return}
        let realmDoit = repository.fetchFilterKey(id: id)
        doit.value = realmDoit
    }
    func getDoitTitle() -> String {
        guard let doit = doit.value else { return "" }
        return doit.title
    }
    func getDoitProgress() -> Double {
        guard let doit = doit.value else { return 0.0}
        return doit.progress()
    }
    func getDoitKey() -> ObjectId?{
        return doitkey.value
    }
    
    func fetchdoitCompleteList() {
        guard let doit = doit.value else { return }
        let doitComplete = doit.doitComplete
        doitcompleteList.value = Array(doitComplete)
    }
    func ListCount() -> Int {
        return doitcompleteList.value.count
    }
    func getListData(index: Int) -> DoitCompleted {
        return doitcompleteList.value[index]
    }
    
    func removeDoit() {
        guard let doit = doit.value else { return }
        let completed = doit.doitComplete
        completed.forEach {
            let fileName = $0.imageTitle + ".jpg"
            FileManager.deleteImageFromDocumentDirectory(imageName: fileName )
        }
        repository.removeItem(doit)
        
    }
    func
    removeCompleted(index : Int){
        guard let doit = doit.value else { return }
        let doitCompleted = getListData(index: index)
        print(doitCompleted._id, "삭제하기전 완료 ID")
        print(index, "삭제하기전 index")
        repository.removeCompletedItem(doit,index: index)
    }
    
    func checkValidDateCompleted(date: Date){
        guard let doitcopmlete = doitcompleteList.value.last  else { return }
        
        let lastDate = doitcopmlete.createDate
        if date.isSameDay(as: lastDate){
            validTodayCompleted.value = false
        }else {
            validTodayCompleted.value = true
        }
    }
    func getValidDateCompleted() -> Bool{
        return validTodayCompleted.value
    }
    func checkValidProgress() {
        guard let doit = doit.value else { return }
        if doit.progress() >= 1.0 {
            vaildProgress.value = false
        }else{
            vaildProgress.value = true
        }
    }
    func getValidProgress() -> Bool{
        return vaildProgress.value
    }
    

}
