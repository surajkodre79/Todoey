//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Suraj Kodre on 13/07/18.
//  Copyright © 2018 Suraj Kodre. All rights reserved.
//

import UIKit
import CoreData

class CategoryListTableViewController: UITableViewController {

    var categoryList = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let catList = CoreDataManager.sharedInstance.fetchItems(with: .typeCategory, predicate: nil) as? [Category] {
            categoryList = catList
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryList.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryList[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItemsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItemsSegue" {
            let destinationVC = segue.destination as! TodoListViewController
            if let index = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categoryList[index.row]
            }
        }
    }
  
    @IBAction func addCategoryButClick(_ sender: Any) {
        let popup = PopUpManager().createPouUp(type: .typeCategory, selectedCategry: nil) { (catergory) in
            self.categoryList = catergory as! [Category]
            self.tableView.reloadData()
        }
        
        self.present(popup, animated: true, completion: nil)
        
    }
    
}
