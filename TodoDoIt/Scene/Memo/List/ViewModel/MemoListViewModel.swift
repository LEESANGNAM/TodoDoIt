//
//  MemoListViewModel.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/11/05.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

class MemoListViewModel {
    
    struct Input{
        let viewWillAppear: Observable<Void>
        let cellTap: ControlEvent<IndexPath>
        let modelSelect: ControlEvent<Memo>
    }
    struct OutPut{
        var memoArray: PublishRelay<[Memo]>
    }
    
    var disposeBag = DisposeBag()
    
    let dismissModal = PublishRelay<Void>()
    
    func transform(input: Input) -> OutPut {
        let repository = MemoRepository()
        var memoArray = PublishRelay<[Memo]>()
        
        input.viewWillAppear
            .bind(with: self) { owner, _ in
                let memoData = repository.fetch()
                let memoDataArray = Array(memoData)
                memoArray.accept(memoDataArray)
            }.disposed(by: disposeBag)
        
        dismissModal
            .bind(with: self) { owner, _ in
                let memoData = repository.fetch()
                let memoDataArray = Array(memoData)
                memoArray.accept(memoDataArray)
            }.disposed(by: disposeBag)
        
        return OutPut(memoArray: memoArray)
    }
}
