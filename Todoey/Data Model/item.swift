//
//  item.swift
//  Todoey
//
//  Created by KAVIRAJ PANDEY on 11/07/19.
//  Copyright © 2019 KAVIRAJ PANDEY. All rights reserved.
//

import Foundation

//Class must conforms to Encodable protocol it means Item now encode itself into a plist or json and all property must be standard data type
class Item: Codable {
    var title: String = ""
    var done: Bool = false
}
