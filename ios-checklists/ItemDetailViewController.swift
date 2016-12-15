//
//  ItemDetailViewController.swift
//  ios-checklists
//
//  Created by Chaofan Zhang on 11/24/16.
//  Copyright © 2016 Chaofan Zhang. All rights reserved.
//

import UIKit
import UserNotifications

protocol ItemDetailViewControllerProtocol: class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController : UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var remindMeSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var datePickerVisible = false
    var dueDate = Date()
    
    weak var delegate: ItemDetailViewControllerProtocol?
    
    var itemToEdit: ChecklistItem?
    

    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        print("text field: \(textField.text!)")
        if let editItem = itemToEdit {
            editItem.text = textField.text!
            editItem.shouldRemind = remindMeSwitch.isOn
            editItem.dueDate = dueDate
            editItem.scheduleNotification()
            delegate?.itemDetailViewController(self, didFinishEditing: editItem)
        } else {
            let item = ChecklistItem(text: textField.text!, checked: false)
            item.shouldRemind = remindMeSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        }
        return nil
    }
    
    override func viewDidLoad() {
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            remindMeSwitch.isOn = item.shouldRemind
            dueDate = item.dueDate
            updateDueDateLabel()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
        doneBarButton.isEnabled = textField.text!.characters.count > 0
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string)
        
        if (newText.characters.count > 0) {
            doneBarButton.isEnabled = true
        } else {
            doneBarButton.isEnabled = false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }
    
    // MARK: - UITableView DatePickerCell related methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 1 {
            tableView.deselectRow(at: indexPath, animated: true)
            textField.resignFirstResponder()

            if datePickerVisible {
                hideDatePicker()
            } else {
                showDatePicker()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        if indexPath.section == 1 && indexPath.row == 2 {
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }
    
    func showDatePicker() {
        datePickerVisible = true
        
        let indexPathDueDate = IndexPath(row: 1, section: 1)
        let indexPathDatePicker = IndexPath(row: 2, section: 1)
        if let cell = tableView.cellForRow(at: indexPathDueDate) {
            cell.detailTextLabel?.textColor = view.tintColor
        }
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        tableView.reloadRows(at: [indexPathDueDate], with: .none)
        tableView.endUpdates()
        
        datePicker.setDate(dueDate, animated: false)
    }
    
    func hideDatePicker() {
        if !datePickerVisible {
            return
        }
        
        datePickerVisible = false
        let indexPathDueDate = IndexPath(row: 1, section: 1)
        let indexPathDatePicker = IndexPath(row: 2, section: 1)
        if let cell = tableView.cellForRow(at: indexPathDueDate) {
            cell.detailTextLabel?.textColor = UIColor(white: 0, alpha: 0.5)
        }
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPathDueDate], with: .none)
        tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
        tableView.endUpdates()
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        dueDate = sender.date
        updateDueDateLabel()
    }
    
    func updateDueDateLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDateLabel.text = formatter.string(from: dueDate)
    }
    
    @IBAction func remindMeSwitchChanged(_ sender: UISwitch) {
        textField.resignFirstResponder()
        
        if sender.isOn {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {
                granted, error in
            }
        }
    }
}
