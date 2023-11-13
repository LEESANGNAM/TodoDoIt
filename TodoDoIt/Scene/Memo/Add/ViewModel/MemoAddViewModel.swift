//
//  MemoAddViewModel.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/15.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

enum realmErrorType: Error {
    case notdata
}

class MemoAddViewModel: ViewModelType {
    var disposeBag: DisposeBag = .init()
    let repository = MemoRepository()
    
    var memoKey: ObjectId?
    let memo = PublishRelay<Memo?>()
    let memoTitle = Observer<String?>(nil)
    let title = BehaviorRelay<String>(value: "")
    
    let textViewPlaceHolder = "오늘 기억해야 할 것을 기록해보세요~~"
    
    init( memoKey: ObjectId?) {
        self.memoKey = memoKey
    }
    
    struct Input {
        let selectDate: Date
        let viewWillAppear: Observable<Void>
        let addButtonTap: ControlEvent<Void>
        let removeButtonTap: ControlEvent<Void>
        let textViewTextChange: ControlEvent<String>
    }
    
    struct Output {
        let memo: PublishRelay<Memo?>
    }
  
    func transform(input: Input) -> Output {
        let vaild = Observer(false)
        input.viewWillAppear
            .bind(with: self) { owner, _ in
                if let memoKey = owner.memoKey,
                   let result = owner.repository.fetchFilterKey(id: memoKey){
                    owner.memo.accept(result)
                    owner.memoTitle.value = result.title
                }else {
                    owner.memo.accept(nil)
                }
            }.disposed(by: disposeBag)
    
        input.textViewTextChange
            .bind(with: self) { owner, string in
                owner.title.accept(string)
                vaild.value = owner.checkvaild(text: string)
                print(string)
            }.disposed(by: disposeBag)
        
        
        
        input.addButtonTap
            .bind(with: self) { owner, _ in
                print(vaild.value)
                if vaild.value {
                    if let _ = owner.memoKey {
                        owner.updateMemoData()
                        print("업데이트")
                    }else {
                        owner.saveMemoData(date: input.selectDate)
                        print("저장")
                    }
                }
            }.disposed(by: disposeBag)
        
        
        
        return Output(memo: memo)
    }
    

    func checkvaild(text: String) -> Bool{
        if text.isEmpty{
            print("텍스트 비었음")
            return false
        }else if  text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            print("텍스트 엔터랑 공백만 있음")
            return false
        }else if text == textViewPlaceHolder {
            print("플레이스 홀더랑 같음 변경사항없음")
            return false
        }else if let memoText = memoTitle.value,
                 text == memoText {
            print("메모 업데이트 텍스트 변경사항 없음")
            return false
        }else {
            return true
        }
    }
    func removeMemodata() {
        if let searchMemoResult = searchMemo(){
            repository.removeItem(searchMemoResult)
        }
    }

    func updateMemoData(){
        let title = title.value
        if let memoId = memoKey{
            repository.updateItem(value: ["_id":memoId,"title": title])
        }
    }

    func saveMemoData(date:Date) {
        let title = title.value
        let memoData = Memo(title: title, date: date)
        repository.createItem(memoData)
    }
    func searchMemo() -> Memo? {
           guard let memokey = memoKey else { return  nil}
           return repository.fetchFilterKey(id: memokey)
       }
    
}
