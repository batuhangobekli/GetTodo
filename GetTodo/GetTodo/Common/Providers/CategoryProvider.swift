//
//  CategoryProvider.swift
//  GetTodo
//
//  Created by Batuhan Göbekli on 21.11.2020.
//  Copyright © 2020 Batuhan Göbekli. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryProvider {
    
    private static let adapter = RealmObjectAdapter<CategoryModel>()
    
    static let shared = CategoryProvider()
    
    static func categories() -> [CategoryItem] {
        return adapter.objects()?.map({$0.toItem}) ?? []
    }
    
    static func category(for identifier: String) -> CategoryItem? {
        return categoryModel(for: identifier)?.toItem
    }
    
    @discardableResult static func create(with identifier: String) -> CategoryItem {
        guard let model = try? adapter.create(["identifier": identifier]) else {
            fatalError("RealmObjectAdapter failed to create Object. Please check Realm configuration.")
        }
        return model.toItem
    }
    
    static func create(with categoryItem: CategoryItem) {
        if categoryModel(for: categoryItem.identifier) != nil{
            return
        }
        
        guard (try? adapter.create(["identifier": categoryItem.identifier])) != nil else {
            fatalError("RealmObjectAdapter failed to create Object. Please check Realm configuration.")
        }
        update(category: categoryItem)
    }
    
    static func update(category: CategoryItem) {
        guard let model = categoryModel(for: category.identifier) else { return }
        try? RealmService.write {
            model.name = category.name
            model.imageString = category.imageString
            model.hexColorString = category.hexColorString
        }
    }
    
    static func remove(category: CategoryItem) {
        guard let model = categoryModel(for: category.identifier) else { return }
        try? RealmService.remove(model)
    }
}

extension CategoryProvider {
    
    static func token(_ onDidChange: @escaping ()->() ) -> NotificationToken? {
        return adapter.objects()?.observe({ (change) in
            switch change {
            case .update:
                onDidChange()
            default: break
            }
        })
    }
    
    
    static func token(for category: CategoryItem, _ onDidChange: @escaping ()->() ) -> NotificationToken? {
        if let model = categoryModel(for: category.identifier) {
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

extension CategoryProvider {
    static func categoryModel(for identifier: String) -> CategoryModel? {
        return adapter.object(primaryKey: identifier)
    }
}

extension CategoryProvider {
    func createUserCategories() {
        var travelCategory = CategoryItem()
        travelCategory.identifier = "1"
        travelCategory.imageString = "airplane"
        travelCategory.name = "Travel"
        travelCategory.hexColorString = "#f38181"
        CategoryProvider.create(with: travelCategory)

        var workCategory = CategoryItem()
        workCategory.identifier = "2"
        workCategory.imageString = "briefcase.fill"
        workCategory.name = "Work"
        workCategory.hexColorString = "#eaffd0"
        CategoryProvider.create(with: workCategory)

        var musicCategory = CategoryItem()
        musicCategory.identifier = "3"
        musicCategory.imageString = "music.note.list"
        musicCategory.name = "Music"
        musicCategory.hexColorString = "#b83b5e"
        CategoryProvider.create(with: musicCategory)

        var homeCategory = CategoryItem()
        homeCategory.identifier = "4"
        homeCategory.imageString = "house.fill"
        homeCategory.name = "Home"
        homeCategory.hexColorString = "#6a2c70"
        CategoryProvider.create(with: homeCategory)

        var studyCategory = CategoryItem()
        studyCategory.identifier = "5"
        studyCategory.imageString = "pencil"
        studyCategory.name = "Study"
        studyCategory.hexColorString = "#f08a5d"
        CategoryProvider.create(with: studyCategory)

        var shopCategory = CategoryItem()
        shopCategory.identifier = "6"
        shopCategory.imageString = "cart.fill.badge.plus"
        shopCategory.name = "Shoppping"
        shopCategory.hexColorString = "#f9ed69"
        CategoryProvider.create(with: shopCategory)
        
        var artCategory = CategoryItem()
        artCategory.identifier = "7"
        artCategory.imageString = "paintbrush.fill"
        artCategory.name = "Art"
        artCategory.hexColorString = "#ffa62b"
        CategoryProvider.create(with: artCategory)
    }
}



