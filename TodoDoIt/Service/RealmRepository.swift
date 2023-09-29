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
    func updateItem(_ item: T)
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
    func fetchFilterDate(date: Date) -> Results<T> {
        //날짜 의 00:00:00
        let startOfDay = Calendar.current.startOfDay(for: date)
        // 해당 날짜의 23:59:59
        let endOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: date)!
        
        // 해당 일자에 속하는 데이터 가져오기
        return realm.objects(T.self).filter("createDate >= %@ AND createDate <= %@", startOfDay, endOfDay)
    }
    func fetchFilterContainsDate(date: Date) -> Results<T> {
        return realm.objects(T.self).filter("startDate <= %@ AND endDate >= %@", date, date)
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
    
    func updateItem(_ item: T) {
        do {
            try realm.write {
                realm.add(item, update: .modified)
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
