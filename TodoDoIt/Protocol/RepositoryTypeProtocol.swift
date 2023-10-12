//
//  RealmRepository.swift
//  TodoDoIt
//
//  Created by 이상남 on 2023/09/27.
//

import Foundation
import RealmSwift

protocol RepositoryTypeProtocol {
    associatedtype T: RealmCollectionValue
    func fetch() -> Results<T>
    func fetchFilterKey(id: ObjectId) -> T?
    func createItem(_ item: T)
    func updateItem(value: Any)
    func removeItem(_ item: T)

}

