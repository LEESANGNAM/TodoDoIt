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
