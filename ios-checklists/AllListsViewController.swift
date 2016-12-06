//
//  AllListsViewController.swift
//  ios-checklists
//
//  Created by Chaofan Zhang on 11/29/16.
//  Copyright © 2016 Chaofan Zhang. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerProtocol {
    
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataModel.checkLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell(for: tableView)
        cell.accessoryType = .detailDisclosureButton
        
        let list = dataModel.checkLists[indexPath.row]
        cell.textLabel?.text = list.name
        return cell
    }
    
    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let checklist = dataModel.checkLists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle.rawValue == UITableViewCellEditingStyle.delete.rawValue {
            dataModel.checkLists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let navigationController = storyboard!.instantiateViewController(withIdentifier: "ListDetailNavigationController") as! UINavigationController
        let listDetailViewController = navigationController.topViewController as! ListDetailViewController
        listDetailViewController.delegate = self
        listDetailViewController.checklistToEdit = dataModel.checkLists[indexPath.row]
        present(navigationController, animated: true, completion: nil)
    }
    
    
    //MARK: - private methods
    func makeCell(for tableView: UITableView) -> UITableViewCell {
        let cellIdentifier = "allListsCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
    }
    
    //MARK: - ListDetailViewControllerProtocol
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        dataModel.checkLists.append(checklist)
        tableView.insertRows(at: [IndexPath(row: dataModel.checkLists.count - 1, section: 0)], with: .automatic)
        
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        if let row = dataModel.checkLists.index(of: checklist) {
            let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0))
            cell?.textLabel?.text = checklist.name
        }
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller  = segue.destination as! ChecklistViewController
            controller.checklist = sender as! Checklist
        } else if segue.identifier == "AddChecklist" {
            let controller = segue.destination as! UINavigationController
            let listDetailController = controller.topViewController as! ListDetailViewController
            listDetailController.delegate = self
            listDetailController.checklistToEdit = nil
        }
    }

    
}
