//
//  Checklist.swift
//  ios-checklists
//
//  Created by Chaofan Zhang on 11/29/16.
//  Copyright © 2016 Chaofan Zhang. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding {
    var name = ""
    var items = [ChecklistItem]()
    
    init(name: String) {
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        items = aDecoder.decodeObject(forKey: "items") as! [ChecklistItem]
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(items, forKey: "items")
    }
    
    func uncheckedItemCount() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
    }
}
