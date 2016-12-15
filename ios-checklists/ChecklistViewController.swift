//
//  ViewController.swift
//  ios-checklists
//
//  Created by Chaofan Zhang on 11/22/16.
//  Copyright © 2016 Chaofan Zhang. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerProtocol {
    let TAG_LABEL = 1000
    let TAG_CHECK_MARK = 1001
    let TAG_DUE_DATE = 1002
    
    var checklist: Checklist!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = checklist.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: TableView overrides
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = checklist.items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: private methods
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        let checkLabel = cell.viewWithTag(TAG_CHECK_MARK) as! UILabel
        checkLabel.textColor = view.tintColor
        
        if item.checked {
            checkLabel.text = "✔︎"
        } else {
            checkLabel.text = ""
        }
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(TAG_LABEL) as! UILabel
        label.text = item.text
        let dueDate = cell.viewWithTag(TAG_DUE_DATE) as! UILabel
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDate.text = formatter.string(from: item.dueDate)
    }
    
    //MARK: - ItemDetailViewControllerProtocol
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        checklist.items.append(item)
//        let newItemIndex = checklist.items.count
//        let indexPath = IndexPath(item: newItemIndex, section: 0)
//        tableView.insertRows(at: [indexPath], with: .automatic)
        sortChecklistItems()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
//        if let index = checklist.items.index(of: item) {
//            let indexPath = IndexPath(row: index, section: 0)
//            if let cell = tableView.cellForRow(at: indexPath) {
//                configureText(for: cell, with: item)
//            }
//        }
        sortChecklistItems()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
            controller.delegate = self
        }
    }
    
    func sortChecklistItems() {
        checklist.items.sort() {
            item1, item2 in
            return item1.dueDate.compare(item2.dueDate) == .orderedAscending
        }
    }
    
}

