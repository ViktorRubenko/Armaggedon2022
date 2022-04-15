//
//  DatabaseService.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 15.04.2022.
//

import Foundation
import RealmSwift

protocol DatabaseServiceProtocol {
    func add<T: Object>(_ object: T)
    func add<S: Sequence>(_ objects: S) where S.Iterator.Element: Object
    func get<R: Object>(fromEntity entity: R.Type, sortedByKey sortKey: String?, isAscending: Bool) -> Results<R>
    func delete<T: Object>(_ object: T)
    func delete<S: Sequence>(_ objects: S) where S.Iterator.Element: Object
}

final class RealmManager: DatabaseServiceProtocol {
    static let shared = RealmManager()
    private let realm: Realm
    private init() {
        
        let configuration = Realm.Configuration(schemaVersion: 1)
        
        do {
            realm = try Realm.init(configuration: configuration)
        } catch {
            print(error)
            fatalError("Error during creating Realm")
        }
    }
    
    func add<T>(_ object: T) where T: Object {
        realm.beginWrite()
        realm.add(object)
        try! realm.commitWrite()
    }
    
    func add<S>(_ objects: S) where S : Sequence, S.Element : Object {
        realm.beginWrite()
        realm.add(objects)
        try! realm.commitWrite()
    }

    func get<R>(fromEntity entity: R.Type, sortedByKey sortKey: String?, isAscending: Bool) -> Results<R> where R : Object {
        var objects = realm.objects(entity)
        if sortKey != nil {
            objects = objects.sorted(byKeyPath: sortKey!, ascending: isAscending)
        }
        return objects
    }
    
    func delete<S>(_ objects: S) where S : Sequence, S.Element : Object {
        realm.beginWrite()
        realm.delete(objects)
        try! realm.commitWrite()
    }
    
    func delete<T>(_ object: T) where T : Object {
        realm.beginWrite()
        realm.delete(object)
        try! realm.commitWrite()
    }
}
