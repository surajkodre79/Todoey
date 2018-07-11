//
//  ViewController.swift
//  Todoey
//
//  Created by Suraj Kodre on 09/07/18.
//  Copyright © 2018 Suraj Kodre. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemsArray = [Item]()
    
    let fileManager = FileManager.default
    var filePath: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        filePath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
        fetchItems()
    }
    
    //tableview datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        let item = itemsArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.check ? .checkmark : .none
        return cell
    }
    
    //tableview delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemsArray[indexPath.row].check = !itemsArray[indexPath.row].check
        saveItem()
        tableView.reloadData()
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
               let title = textField.text!
               self.itemsArray.append(Item(title: title, check: false))
            }
            self.saveItem()
        }))
        
        self.present(popup, animated: true, completion: nil)
    }
    
    func saveItem() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemsArray)
            if let path = filePath {
                try data.write(to: path)
            }
        } catch {
            print("error in coding array")
        }
        self.tableView.reloadData()
    }
    
    func fetchItems() {
        if let itemData = try? Data(contentsOf: filePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemsArray = try decoder.decode([Item].self, from: itemData)
            } catch {
               print("error while decoding")
            }
        }
    }
    
}

