//
//  ItemDetailViewController.swift
//  ios-checklists
//
//  Created by Chaofan Zhang on 11/24/16.
//  Copyright © 2016 Chaofan Zhang. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerProtocol: class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController : UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    
    weak var delegate: ItemDetailViewControllerProtocol?
    
    var itemToEdit: ChecklistItem?
    

    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        print("text field: \(textField.text!)")
        if let editItem = itemToEdit {
            editItem.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishEditing: editItem)
        } else {
            delegate?.itemDetailViewController(self, didFinishAdding: ChecklistItem(text: textField.text!, checked: false))
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    override func viewDidLoad() {
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text            
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
}
