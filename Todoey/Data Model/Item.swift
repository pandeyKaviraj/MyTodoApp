//
//  Item.swift
//  Todoey
//
//  Created by KAVIRAJ PANDEY on 18/07/19.
//  Copyright © 2019 KAVIRAJ PANDEY. All rights reserved.
//

import Foundation
import RealmSwift


//Item has a inverse relationship with paraent category
class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    //each Item has a parent category that is of the type category and comes from the property called items
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")//category.self is a type, property is name of forward relationship property
   
}

