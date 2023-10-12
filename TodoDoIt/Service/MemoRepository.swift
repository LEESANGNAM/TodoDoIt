//
//  MemoRepository.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/13.
//

import Foundation
import RealmSwift

final class MemoRepository: RepositoryTypeProtocol {
    typealias T = Memo
    private let realm = try! Realm()
    
    func fetch() -> Results<T> {
        return realm.objects(T.self)
    }
    func fetchFilterKey(id: ObjectId) -> T? {
        let data = realm.object(ofType: T.self, forPrimaryKey: id)
        
        return data
    }
    func fetchFilterDate(date: Date) -> Results<T> {
        //날짜 의 00:00:00
        let startOfDay = Calendar.current.startOfDay(for: date)
        // 해당 날짜의 23:59:59
        let endOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: date)!
        
        // 해당 일자에 속하는 데이터 가져오기
        return realm.objects(T.self).filter("createDate >= %@ AND createDate <= %@", startOfDay, endOfDay)
    }
    func createItem(_ item: T) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print(error)
        }
    }
    
    func updateItem(value: Any = [String: Any]()) {
        do {
            try realm.write {
                realm.create(T.self, value: value, update: .modified)
            }
        } catch {
            print(error)
        }
    }
    
    func removeItem(_ item: T) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print(error)
        }
    }
}
