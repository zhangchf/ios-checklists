//
//  ChecklistItem.swift
//  ios-checklists
//
//  Created by Chaofan Zhang on 11/24/16.
//  Copyright © 2016 Chaofan Zhang. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding {
    var text = ""
    var checked = false
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "text") as! String
        checked = aDecoder.decodeBool(forKey: "checked")
        super.init()
    }
    
    init(text: String, checked: Bool) {
        self.text = text
        self.checked = checked
    }
    
    func toggleChecked() {
        checked = !checked
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "text")
        aCoder.encode(checked, forKey: "checked")
    }
}
