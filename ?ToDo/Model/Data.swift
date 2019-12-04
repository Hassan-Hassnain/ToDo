//
//  Data.swift
//  ?ToDo
//
//  Created by Usama Sadiq on 12/3/19.
//  Copyright © 2019 Usama Sadiq. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
