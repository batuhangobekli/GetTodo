//
//  TaskProvider.swift
//  GetTodo
//
//  Created by Batuhan Göbekli on 22.11.2020.
//  Copyright © 2020 Batuhan Göbekli. All rights reserved.
//

import Foundation
import RealmSwift

class TaskProvider {
    
    private static let adapter = RealmObjectAdapter<TaskModel>()
    
    static let shared = TaskProvider()
    
    static func tasks() -> [TaskItem] {
        return adapter.objects()?
            .filter("userId == %@", TempDataHolder.shared.currentUserId)
            .map({$0.toItem}) ?? []
    }
    
    
    static func tasks(categoryId:String) -> [TaskItem] {
        return adapter.objects(TaskModel.self)?
            .filter("categoryId == %@", categoryId)
            .filter("userId == %@", TempDataHolder.shared.currentUserId)
            .map({$0.toItem}) ?? []
    }
    
    static func create(task:TaskItem){
        guard (try? adapter.create(["taskDescription":task.taskDescription,"date":task.date,"categoryId":task.categoryId,"userId":TempDataHolder.shared.currentUserId])) != nil else
        {
                fatalError("RealmObjectAdapter failed to create Object. Please check Realm configuration.")
        }
    }
    
    
    static func update(task: TaskItem) {
        guard let model = taskModel(for: task.identifier) else { return }
        try? RealmService.write {
            model.date = task.date
            model.taskDescription = task.taskDescription
            model.userId = task.userId
            model.categoryId = task.categoryId
        }
    }
    
    static func remove(task: TaskItem) {
        guard let model = taskModel(for: task.identifier) else { return }
        try? RealmService.remove(model)
    }
}

extension TaskProvider {
    
    static func token(_ onDidChange: @escaping ()->() ) -> NotificationToken? {
        return adapter.objects()?.observe({ (change) in
            switch change {
            case .update:
                onDidChange()
            default: break
            }
        })
    }
    
    
    static func token(for task: TaskItem, _ onDidChange: @escaping ()->() ) -> NotificationToken? {
        if let model = taskModel(for: task.identifier) {
            return model.observe { (change) in
                switch change {
                case .change: onDidChange()
                case .deleted: break
                default: break
                }
            }
        }
        return nil
    }
}

extension TaskProvider {
    static func taskModel(for identifier: String) -> TaskModel? {
        return adapter.object(primaryKey: identifier)
    }
}

