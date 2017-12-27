//
//  Category.swift
//  Todoey
//
//  Created by Pradeep Chandrasekaran on 27/12/17.
//  Copyright © 2017 Pradeep Chandrasekaran. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
  
  @objc dynamic var name: String = ""
  let items = List<Item>()
  
}
