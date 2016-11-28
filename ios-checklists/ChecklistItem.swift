//
//  ChecklistItem.swift
//  ios-checklists
//
//  Created by Chaofan Zhang on 11/24/16.
//  Copyright © 2016 Chaofan Zhang. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject {
    var text = ""
    var checked = false
    
    override init() {
        super.init()
    }
    
    init(text: String, checked: Bool) {
        self.text = text
        self.checked = checked
    }
    
    func toggleChecked() {
        checked = !checked
    }
}
