//
//  Item.swift
//  Todoey
//
//  Created by Pradeep Chandrasekaran on 27/12/17.
//  Copyright © 2017 Pradeep Chandrasekaran. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
  
  @objc dynamic  var title: String = ""
  @objc dynamic var done: Bool = false
  var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
  
}
