//
//  Category.swift
//  Todoey
//
//  Created by KAVIRAJ PANDEY on 18/07/19.
//  Copyright © 2019 KAVIRAJ PANDEY. All rights reserved.
//

import Foundation
import RealmSwift

//Category class has one to many relationship with a list Item objects
class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    //Below forward relationship with list of Item object
    let items = List<Item>()
}
