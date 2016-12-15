//
//  DataModel.swift
//  ios-checklists
//
//  Created by Chaofan Zhang on 12/6/16.
//  Copyright © 2016 Chaofan Zhang. All rights reserved.
//

import Foundation

class DataModel {
    let KEY_CHECK_LIST_INDEX = "checklistIndex"
    let KEY_FIRST_TIME = "firstTime"
    static let KEY_CHECK_LIST_ITEM_ID = "checklistItemId"
    
    var checkLists = [Checklist]()
    
    let userDefaults = UserDefaults.standard
    
    var indexOfSelectedChecklist: Int {
        get {
            return userDefaults.integer(forKey: KEY_CHECK_LIST_INDEX)
        }
        set {
            userDefaults.set(newValue, forKey: KEY_CHECK_LIST_INDEX)
            userDefaults.synchronize()
            print("set checklist index to \(newValue)")
        }
    }
    
    var firstTime: Bool {
        get {
            return userDefaults.bool(forKey: KEY_FIRST_TIME)
        }
        set {
            userDefaults.set(newValue, forKey: KEY_FIRST_TIME)
        }
    }
    
    init() {
        print("documentsDirectory: \(documentsDirectory())")
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    //MARK: data persistance
    func documentsDirectory() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    
    func saveChecklists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(checkLists, forKey: "Checklists")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
    func loadChecklists() {
        if let data = try? Data(contentsOf: dataFilePath()) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            checkLists = unarchiver.decodeObject(forKey: "Checklists") as! [Checklist]
            unarchiver.finishDecoding()
        }
    }
    
    func registerDefaults() {
        let defaultValues = [KEY_CHECK_LIST_INDEX: -1,
                             KEY_FIRST_TIME: true,
                             DataModel.KEY_CHECK_LIST_ITEM_ID: 0] as [String : Any]
        userDefaults.register(defaults: defaultValues)
    }
    
    func handleFirstTime() {
        if firstTime {
            checkLists.append(Checklist(name: "List"))
            firstTime = false
            
            indexOfSelectedChecklist = 0
            userDefaults.synchronize()
        }
    }
    
    class func newChecklistItemId() -> Int {
        let itemId = UserDefaults.standard.integer(forKey: KEY_CHECK_LIST_ITEM_ID)
        UserDefaults.standard.set(itemId + 1, forKey: KEY_CHECK_LIST_ITEM_ID)
        return itemId
    }


}
