//
//  CategoryModel.swift
//  GetTodo
//
//  Created by Batuhan Göbekli on 21.11.2020.
//  Copyright © 2020 Batuhan Göbekli. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryModel: Object {
    @objc dynamic var identifier = ""
    @objc dynamic var name = ""
    @objc dynamic var imageString = ""
    @objc dynamic var hexColorString = ""
    
    override static func primaryKey() -> String? {
      return "identifier"
    }
}

extension CategoryModel {
    var toItem: CategoryItem {
        return CategoryItem(with: self)
    }
}
