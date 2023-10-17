//
//  DoitCompleteAddViewModel.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/13.
//

import Foundation
import RealmSwift
import UIKit

class DoitCompleteAddViewModel {
    let repository = DoitRepository()
    var doit = Observer<DoIt?>(nil)
    var doitKey = Observer<ObjectId?>(nil)
   
    func updateValue(complete: DoitCompleted){
        guard let key = doitKey.value else { return }
        repository.appendCompletedItem(doItId: key, completedItem: complete)
    }
    
    func fetchDoit(){
        guard let key = doitKey.value else { return }
        let doitData = repository.fetchFilterKey(id: key)
        doit.value = doitData
    }
    func getDoit() -> DoIt?{
         return doit.value
    }
    
    func saveImage(image: UIImage?,imageName: String){
        guard let image else { return }
        print(FileManager.saveImageToDocumentDirectory(image: image, fileName: imageName))
    }
}
