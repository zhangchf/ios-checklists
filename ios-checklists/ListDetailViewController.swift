//
//  ListDetailViewController.swift
//  ios-checklists
//
//  Created by Chaofan Zhang on 11/29/16.
//  Copyright © 2016 Chaofan Zhang. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerProtocol {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    
    var delegate: ListDetailViewControllerProtocol?
    var checklistToEdit: Checklist?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let checklist = checklistToEdit {
            textField.text = checklist.name
            self.title = "Edit Checklist"
        }
        doneButton.isEnabled = textField.text!.characters.count > 0
        textField.delegate = self
        textField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string)
        doneButton.isEnabled = newText.characters.count > 0
        return true
    }
        
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let checklist = checklistToEdit {
            checklist.name = textField.text!
            delegate?.listDetailViewController(self, didFinishEditing: checklist)
        } else {
            delegate?.listDetailViewController(self, didFinishAdding: Checklist(name: textField.text!))
        }
    }
    
}
