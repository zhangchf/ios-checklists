//
//  ChecklistItem.swift
//  ios-checklists
//
//  Created by Chaofan Zhang on 11/24/16.
//  Copyright © 2016 Chaofan Zhang. All rights reserved.
//

import Foundation
import UserNotifications

class ChecklistItem: NSObject, NSCoding {
    var text = ""
    var checked = false
    var dueDate = Date()
    var shouldRemind = false
    var itemId: Int

    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "text") as! String
        checked = aDecoder.decodeBool(forKey: "checked")
        dueDate = aDecoder.decodeObject(forKey: "dueDate") as! Date
        shouldRemind = aDecoder.decodeBool(forKey: "shouldRemind")
        itemId = aDecoder.decodeInteger(forKey: "itemId")
        super.init()
    }
    
    init(text: String, checked: Bool) {
        self.text = text
        self.checked = checked
        self.itemId = DataModel.newChecklistItemId()
    }
    
    deinit {
        removeNotification()
    }
    
    func toggleChecked() {
        checked = !checked
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "text")
        aCoder.encode(checked, forKey: "checked")
        aCoder.encode(dueDate, forKey: "dueDate")
        aCoder.encode(shouldRemind, forKey: "shouldRemind")
        aCoder.encode(itemId, forKey: "itemId")
    }
    
    func scheduleNotification() {
        removeNotification()
        if shouldRemind && dueDate > Date() {
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default()
            
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.month, .day, .hour, .minute], from: dueDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let request = UNNotificationRequest(identifier: "\(itemId)", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            print("Notification \(itemId) is scheduled")
        }
    }
    
    func removeNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(itemId)"])
    }
}
