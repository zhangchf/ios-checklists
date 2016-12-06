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
    
    var checkLists = [Checklist]()
    
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: KEY_CHECK_LIST_INDEX)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: KEY_CHECK_LIST_INDEX)
            UserDefaults.standard.synchronize()
            print("set checklist index to \(newValue)")
        }
    }
    
    var firstTime: Bool {
        get {
            return UserDefaults.standard.bool(forKey: KEY_FIRST_TIME)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: KEY_FIRST_TIME)
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
        let defaultValues = [KEY_CHECK_LIST_INDEX: -1, KEY_FIRST_TIME: true] as [String : Any]
        UserDefaults.standard.register(defaults: defaultValues)
    }
    
    func handleFirstTime() {
        if firstTime {
            checkLists.append(Checklist(name: "List"))
            firstTime = false
            
            indexOfSelectedChecklist = 0
            UserDefaults.standard.synchronize()
        }
    }


}
