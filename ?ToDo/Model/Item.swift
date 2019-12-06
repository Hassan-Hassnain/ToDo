//
//  Item.swift
//  ?ToDo
//
//  Created by Usama Sadiq on 12/3/19.
//  Copyright © 2019 Usama Sadiq. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    @objc dynamic var itemColor: String?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
