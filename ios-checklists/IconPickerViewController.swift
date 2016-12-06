//
//  IconPickerViewController.swift
//  ios-checklists
//
//  Created by Chaofan Zhang on 12/6/16.
//  Copyright © 2016 Chaofan Zhang. All rights reserved.
//

import UIKit

protocol IconPickerViewControllerDelegate: class {
    func iconPickerViewController(_ viewController: IconPickerViewController, didPick iconName: String)
}

class IconPickerViewController: UITableViewController {
    
    let IDENTIFIER_ICON_PICKER_CELL = "iconPickerCell"
    
    weak var delegate: IconPickerViewControllerDelegate?
    
    let icons = [
        "No Icon",
        "Appointments",
        "Birthdays",
        "Chores",
        "Drinks",
        "Folder",
        "Groceries",
        "Inbox",
        "Photos",
        "Trips" ]
    
    
    
    //MARK: - UITableView Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_ICON_PICKER_CELL, for: indexPath)
        
        let iconName = icons[indexPath.row]
        cell.textLabel?.text = iconName
        cell.imageView?.image = UIImage(named: iconName)
        return cell
    }
    
    //MARK: - UITableView delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.iconPickerViewController(self, didPick: icons[indexPath.row])
    }
    
    //MARK: - IBAction
    @IBAction func cancel() {
        let _ = navigationController?.popViewController(animated: true)
    }
}
