//
//  ViewController.swift
//  Todoey
//
//  Created by Suraj Kodre on 09/07/18.
//  Copyright © 2018 Suraj Kodre. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemsArray = [String]()
    
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let list = defaults.value(forKey: "toDoList") as? [String] {
            itemsArray = list
        }
    }
    
    //tableview datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        cell.textLabel?.text = itemsArray[indexPath.row]
        return cell
    }
    
    //tableview delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    @IBAction func addItemsToList(_ sender: Any) {
        var textField = UITextField()
       
        let popup = UIAlertController.init(title: "Add Item To List", message: "Please Enter Item", preferredStyle: .alert)
        popup.addTextField(configurationHandler: { (alertTextField) in
            alertTextField.placeholder = "Item"
            textField = alertTextField
        })
        popup.addAction(UIAlertAction.init(title: "Add", style: .default, handler: { (action) in
            if !(textField.text?.isEmpty)! {
               self.itemsArray.append(textField.text!)
               self.defaults.set(self.itemsArray, forKey: "toDoList")
            }
            self.tableView.reloadData()
        }))
        
        self.present(popup, animated: true, completion: nil)
    }
    
}

