//
//  ListOfCategories.swift
//  TooDooDoo List
//
//  Created by Timofei Sopin on 2018-02-19.
//  Copyright © 2018 Centennial College. All rights reserved.
//

import Foundation
import RealmSwift

class ListOfCategories: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    let items = List<ListOfItems>()
}


