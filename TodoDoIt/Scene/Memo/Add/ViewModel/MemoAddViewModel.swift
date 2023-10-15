//
//  MemoAddViewModel.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/15.
//

import Foundation
import RealmSwift

class MemoAddViewModel {
    let repository = MemoRepository()
    let textViewPlaceHolder = "오늘 기억해야 할 것을 기록해보세요~~"
    var memoKey = Observer<ObjectId?>(nil)
    var memo = Observer<Memo?>(nil)
    var title = Observer("")
    
    func fetchMemo() {
        guard let memokey = memoKey.value else { return }
        memo.value = repository.fetchFilterKey(id: memokey)
    }
    
    func getMemo() -> Memo? {
        return memo.value
    }
    
    func checkvaild() -> Bool{
        let text = title.value
        if text.isEmpty{
            print("텍스트 비었음")
            return false
        }else if  text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            print("텍스트 엔터랑 공백만 있음")
            return false
        }else if text == textViewPlaceHolder {
            print("플레이스 홀더랑 같음 변경사항없음")
            return false
        }else if let memoText = memo.value?.title,
                 text == memoText {
            print("메모 업데이트 텍스트 변경사항 없음")
            return false
        }else {
            return true
        }
    }

    
    func removeMemodata() {
        guard let memo = memo.value else { return }
        repository.removeItem(memo)
    }
    
    func updateMemoData(){
        guard let memo = memo.value else { return }
        let title = title.value
        repository.updateItem(value: ["_id":memo._id,"title": title])
        
    }
    
    func saveMemoData(date:Date) {
        let title = title.value
        let memoData = Memo(title: title, date: date)
        repository.createItem(memoData)
    }
    
    
}
