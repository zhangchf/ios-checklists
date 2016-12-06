//
//  DataModel.swift
//  ios-checklists
//
//  Created by Chaofan Zhang on 12/6/16.
//  Copyright © 2016 Chaofan Zhang. All rights reserved.
//

import Foundation

class DataModel {
    var checkLists = [Checklist]()
    
    init() {
        print("documentsDirectory: \(documentsDirectory())")
        loadChecklists()
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


}
