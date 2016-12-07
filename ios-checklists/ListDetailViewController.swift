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

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
    let ID_PICK_ICON_SEGUE = "pickIconSegue"

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var delegate: ListDetailViewControllerProtocol?
    var checklistToEdit: Checklist?
    
    var iconName = "Folder"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let checklist = checklistToEdit {
            textField.text = checklist.name
            self.title = "Edit Checklist"
            iconName = checklist.iconName
            iconImageView.image = UIImage(named: checklist.iconName)
        }
        doneButton.isEnabled = textField.text!.characters.count > 0
        textField.delegate = self
        textField.becomeFirstResponder()    }

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
            checklist.iconName = iconName
            delegate?.listDetailViewController(self, didFinishEditing: checklist)
        } else {
            let checklist = Checklist(name: textField.text!, iconName: iconName)
            delegate?.listDetailViewController(self, didFinishAdding: checklist)
        }
    }
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ID_PICK_ICON_SEGUE {
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }
    
    //MARK: - IconPickerViewControllerDelegate
    func iconPickerViewController(_ viewController: IconPickerViewController, didPick iconName: String) {
        self.iconName = iconName
        iconImageView.image = UIImage(named: iconName)
        let _ = navigationController?.popViewController(animated: true)
    }
    
}
