//
//  DatabaseService.swift
//  Armaggedon 2022
//
//  Created by Victor Rubenko on 15.04.2022.
//

import Foundation
import RealmSwift
import Combine

protocol DatabaseServiceProtocol {
    var changes: CurrentValueSubject<Bool, Never> { get }
    func add<T: Object>(_ object: T)
    func get<R: Object>(fromEntity entity: R.Type, sortedByKey sortKey: String?, isAscending: Bool) -> Results<R>
    func delete<T: Object>(_ object: T)
    func delete<S: Sequence>(_ objects: S) where S.Iterator.Element: Object
    func exists<T: Object>(id: String, ofType: T.Type) -> Bool
}

final class RealmManager: DatabaseServiceProtocol {
    static let shared = RealmManager()
    private(set) var changes = CurrentValueSubject<Bool, Never>(false)
    private let realm: Realm
    private var token: NotificationToken!
    
    private init() {
        
        let configuration = Realm.Configuration(schemaVersion: 1)
        
        do {
            realm = try Realm.init(configuration: configuration)
        } catch {
            fatalError("Error during creating Realm")
        }
        token = realm.observe { [weak self] notification, realm in
            self?.changes.send(true)
        }
    }
    
    deinit {
        token.invalidate()
    }
    
    func add<T>(_ object: T) where T: Object {
        realm.beginWrite()
        realm.add(object)
        try! realm.commitWrite()
    }
    
    func get<R>(
        fromEntity entity: R.Type ,
        sortedByKey sortKey: String?,
        isAscending: Bool) -> Results<R> where R : Object {
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
    
    func exists<T>(id: String, ofType: T.Type) -> Bool where T : Object {
        realm.object(ofType: ofType, forPrimaryKey: id) != nil
    }
    
}
