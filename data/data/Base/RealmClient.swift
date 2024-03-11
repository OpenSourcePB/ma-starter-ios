//
//  RealmClient.swift
//  data
//
//  Created by Rza Ismayilov on 02.08.23.
//

import Foundation
import RealmSwift
import Realm
import domain


protocol RealmClientProtocol: Actor {
    func find<T: Object, PK: CVarArg>(pk: PK) -> T?

    func read<T: Object>() -> [T]
    func read<T: Object>(with predicate: NSPredicate) -> [T]
    func read<T: Object>(when match: @escaping (T) -> Bool) -> [T]

    func update(transaction: @escaping () -> Void) throws

    func write<T: Object>(objects: some Sequence<T>) throws
    func delete<T: Object>(objects: some Sequence<T>) throws
    func delete<T: Object>(of: T.Type, with predicate: NSPredicate) throws
    func delete<T: Object>(of: T.Type, when match: @escaping (T) -> Bool) throws
    func deleteAll<T: Object>(of: T.Type) throws

    func replace<T: Object>(old: some Sequence<T>, new: some Sequence<T>) throws
    func replace<T: Object>(objects: some Sequence<T>, with predicate: NSPredicate) throws
    func replace<T: Object>(objects: some Sequence<T>, when match: @escaping (T) -> Bool) throws
    func replace<T: Object>(objects: some Sequence<T>) throws
}

final actor RealmClient: RealmClientProtocol {
    private var tokens: Set<NotificationToken> = .init()
    private var realm: Realm!

    init() async {
        self.realm = try! await Realm(
            configuration: .init(deleteRealmIfMigrationNeeded: true),
            actor: self
        )
    }

    func find<T: Object, PK: CVarArg>(pk: PK) -> T? {
        self.realm.object(ofType: T.self, forPrimaryKey: pk)
    }

    func read<T: Object>() -> [T] {
        self.realm.objects(T.self).map { $0 }
    }

    func read<T: Object>(with predicate: NSPredicate) -> [T] {
        self.realm.objects(T.self)
            .filter(predicate)
            .map { $0 }
    }

    func read<T: Object>(when match: @escaping (T) -> Bool) -> [T] {
        self.realm.objects(T.self).filter(match)
    }

    func update(transaction: @escaping () -> Void) throws {
        try self.realm.write {
            transaction()
        }
    }

    func write<T: Object>(objects: some Sequence<T>) throws {
        try self.realm.write {
            self.realm.add(objects, update: .modified)
        }
    }

    func delete<T: Object>(objects: some Sequence<T>) throws {
        try self.realm.write {
            self.realm.delete(objects)
        }
    }

    func delete<T: Object>(of: T.Type, with predicate: NSPredicate) throws {
        let objects: [T] = self.read(with: predicate)
        try self.delete(objects: objects)
    }

    func delete<T: Object>(of: T.Type, when match: @escaping (T) -> Bool) throws {
        let objects: [T] = self.read(when: match)
        try self.delete(objects: objects)
    }

    func deleteAll<T: Object>(of: T.Type) throws {
        let objects: [T] = self.read()
        try self.delete(objects: objects)
    }

    func replace<T: Object>(old: some Sequence<T>, new: some Sequence<T>) throws {
        try self.realm.write {
            self.realm.delete(old)
            self.realm.add(new, update: .modified)
        }
    }

    func replace<T: Object>(objects: some Sequence<T>, with predicate: NSPredicate) throws {
        let old: [T] = self.read(with: predicate)
        try self.replace(old: old, new: objects)
    }

    func replace<T: Object>(objects: some Sequence<T>, when match: @escaping (T) -> Bool) throws {
        let old: [T] = self.read(when: match)
        try self.replace(old: old, new: objects)
    }

    func replace<T: Object>(objects: some Sequence<T>) throws {
        let old: [T] = self.read()
        try self.replace(old: old, new: objects)
    }

    func observe<T: Object, PK: CVarArg>(_ type: T.Type, pk: PK, onChange: @escaping (T?) -> Void) {
        guard let pkName = T.primaryKey() else { return }
        let predicate = NSPredicate(format: "\(pkName) == %@", pk)
        let token = self.realm.objects(T.self).filter(predicate).observe { _ in
            onChange(self.find(pk: pk))
        }
        self.tokens.insert(token)
    }

    func observe<T: Object>(_ type: T.Type, onChange: @escaping ([T]) -> Void) {
        let token = self.realm.objects(T.self).observe { _ in
            onChange(self.read())
        }
        self.tokens.insert(token)
    }

    func observe<T: Object>(_ type: T.Type, with predicate: NSPredicate, onChange: @escaping ([T]) -> Void) {
        let token = self.realm.objects(T.self).filter(predicate).observe { _ in
            onChange(self.read(with: predicate))
        }
        self.tokens.insert(token)
    }
}

extension Collection where Element: Object {
    func freeze() -> [Element] {
        self.map { $0.freeze() }
    }
}
