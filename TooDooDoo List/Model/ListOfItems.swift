//
//  ListOfItems.swift
//  TooDooDoo List
//
//  Created by Timofei Sopin on 2018-02-19.
//  Copyright © 2018 Centennial College. All rights reserved.
//

import Foundation
import RealmSwift

class ListOfItems: Object {
    
    
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var creationDate : Date?
    
    var parentCategoty = LinkingObjects(fromType: ListOfCategories.self, property: "items")
}
