//
//  RealmRepository.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/09/27.
//

import Foundation
import RealmSwift

protocol RepositoryType {
    associatedtype T: RealmCollectionValue
    func fetch() -> Results<T>
    func createItem(_ item: T)
    func updateItem(value: Any)
    func removeItem(_ item: T)
}

final class Repository<T: Object>: RepositoryType {
    
    private let realm = try! Realm()
    
    init(){
        print(realm.configuration.fileURL!)
    }
    
    func fetch() -> Results<T> {
        return realm.objects(T.self)
    }
    func fetchFilterDateSortByFinish(date: Date) -> Results<T>{
        let filterDate = fetchFilterDate(date: date)
        return filterDate.sorted(byKeyPath: "finish",ascending: true)
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
    func fetchFilterContainsDate(date: Date) -> Results<T> {
        let endOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: date)!
        return realm.objects(T.self).filter("startDate <= %@ AND endDate >= %@", endOfDay, endOfDay)
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
//                realm.add(item, update: .modified)
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
