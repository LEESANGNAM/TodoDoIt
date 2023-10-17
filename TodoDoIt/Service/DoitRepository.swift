//
//  DoitRepository.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/10/13.
//

import Foundation
import RealmSwift

final class DoitRepository: RepositoryTypeProtocol {
    typealias T = DoIt
    
    private let realm = try! Realm()
    
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
        let  startOfDay = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: date)!
        let endOfDay = Calendar.current.startOfDay(for: date)
        return realm.objects(T.self).filter("startDate <= %@ AND endDate >= %@", startOfDay, endOfDay)
    }
    func createItem(_ item: T) {
        do {
            try realm.write {
                realm.add(item)
            }
            print(realm.configuration.fileURL)
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
    
    func appendCompletedItem(doItId: ObjectId, completedItem: DoitCompleted) {
        do {
            try realm.write {
                // 해당 doItId에 해당하는 Doit 객체 가져오기
                if let doIt = fetchFilterKey(id: doItId) {
                    // Doit 객체의 completed 속성에 새로운 Completed 객체 추가
                    doIt.doitComplete.append(completedItem)
                } else {
                    print("해당하는 Doit 객체를 찾을 수 없습니다.")
                }
            }
        } catch {
            print(error)
        }
    }
    func removeCompletedItem(_ item: T, index: Int) {
        do {
            try realm.write {
                realm.delete(item.doitComplete[index])
            }
        } catch {
            print(error)
        }
    }
    
    func removeItem(_ item: T) {
        do {
            try realm.write {
                realm.delete(item.doitComplete)
                realm.delete(item)
            }
        } catch {
            print(error)
        }
    }
    
    
    
    
    
}
