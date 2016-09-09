//
//  Item.swift
//  ChangingTableViewController
//
//  Created by xszhao on 2016-01-03.
//  Copyright © 2016 xszhao. All rights reserved.
//

import Foundation

//what does Equatable mean?
//to make a set you have to make it conform to both equatable and hashable
struct Item: Equatable, Hashable {
    let name: String
    let imageName: String
    let price: Double
    
    
    var Id: Int
    var hashValue: Int {
        get {
            return Id.hashValue << 15 + name.hashValue
        }
    }
}

func ==(lhs: Item, rhs: Item) -> Bool {
    return lhs.name == rhs.name
}
