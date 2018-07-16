//
//  ViewController.swift
//  Todoey
//
//  Created by Suraj Kodre on 09/07/18.
//  Copyright © 2018 Suraj Kodre. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemsArray = [Item]()
    
    var selectedCategory: Category? {
        didSet {
            filterItemsAccordingParentCat()
        }
    }
    
    func filterItemsAccordingParentCat() {
        let predicate = NSPredicate(format: "parentCategory.title MATCHES %@", (selectedCategory?.title)!)
        itemsArray = CoreDataManager.sharedInstance.fetchItems(with: .typeItem, predicate: predicate) as! [Item]
    }
    
    let fileManager = FileManager.default
    var filePath: URL?
    @IBOutlet weak var searchBar: UISearchBar!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        CoreDataManager.sharedInstance.saveItem()
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    @IBAction func addItemsToList(_ sender: Any) {
        
        let popup = PopUpManager().createPouUp(type: .typeItem, selectedCategry: selectedCategory!) { (itemsList) in
            self.itemsArray = itemsList as! [Item]
            self.tableView.reloadData()
        }
        self.present(popup, animated: true, completion: nil)
    }
    
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count == 0 {
            return
        }
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        itemsArray = CoreDataManager.sharedInstance.fetchItems(with: .typeItem, predicate: predicate) as! [Item]
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            itemsArray = CoreDataManager.sharedInstance.fetchItems(with: .typeItem, predicate: NSPredicate(format: "parentCategory.title MATCHES %@", (selectedCategory?.title)!)) as! [Item]
            tableView.reloadData()
        }
    }
    
    
    
}

