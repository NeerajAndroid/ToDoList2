//
//  TaskModel.swift
//  ToDoList2
//
//  Created by Neeraj Sahu on 16/03/25.
//

import Foundation
//import RealmSwift

struct TaskModel {
    var id: String
    var caption: String
    var category: CategoryModel
    var createdAt: Date
    var isCompleted: Bool
    
    mutating func updateCaption(_ newCaption: String) {
        self.caption = newCaption
    }
    
    mutating func updateCategory(_ newCategory: CategoryModel) {
        self.category = newCategory
    }
}

//class TaskObject: Object {
//    @Persisted(primaryKey: true) var _id: String
//    @Persisted var caption: String = ""
//    @Persisted var category = CategoryModel.exercise
//    @Persisted var isCompleted: Bool
//    @Persisted var createdAt: Date
//    
//}
