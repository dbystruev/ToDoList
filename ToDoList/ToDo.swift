//
//  ToDo.swift
//  ToDoList
//
//  Created by Denis Bystruev on 22/10/2018.
//  Copyright © 2018 Denis Bystruev. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class ToDo: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isComplete: Bool = false
    @objc dynamic var dueDate: Date = Date()
    @objc dynamic var notes: String? = nil
    
    // Get the default Realm
    static let realm = try! Realm()
    
    init(title: String, isComplete: Bool, dueDate: Date, notes: String?) {
        self.title = title
        self.isComplete = isComplete
        self.dueDate = dueDate
        self.notes = notes
        super.init()
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    static func loadToDos() -> [ToDo]? {
        var todos = [ToDo]()
        let todoObjects = realm.objects(ToDo.self)
        print(#function, todoObjects.count)
        for todo in todoObjects {
            todos.append(todo)
        }
        return todos
    }
    
    static func loadSampleToDos() -> [ToDo] {
        return []
    }
    
    static let dueDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}
