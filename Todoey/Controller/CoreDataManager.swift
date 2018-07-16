//
//  CoreDataManager.swift
//  Todoey
//
//  Created by Suraj Kodre on 13/07/18.
//  Copyright © 2018 Suraj Kodre. All rights reserved.
//

import Foundation
import CoreData
import UIKit

enum ManagedObjectType: String  {
    case typeItem = "Item"
    case typeCategory = "Category"
}

class CoreDataManager {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private init() {}
    
    static var sharedInstance = CoreDataManager()
    
    func saveItem() {
        do {
            try context.save()
        } catch {
            print("Error while saving data \(error)")
        }
    }
    
    func fetchItems(with type: ManagedObjectType, predicate: NSPredicate?) -> [NSManagedObject] {
        var array = [NSManagedObject]()
        
        switch type {
        case .typeItem:
            let request: NSFetchRequest<Item> = Item.fetchRequest()
            if let predicate = predicate {
                request.predicate = predicate
            }
            do {
               array = try context.fetch(request)
            } catch {
               print("Error while fetching items data")
            }
            
        case .typeCategory:
            let request: NSFetchRequest<Category> = Category.fetchRequest()
            if let predicate = predicate {
                request.predicate = predicate
            }
            do {
                array  = try context.fetch(request)
            } catch {
                print("Error while fatching category data")
            }
        }
       return array
    }
    
    func appendItemsOfType (typeName: ManagedObjectType, tielText: String, selectedCategry: Category?) -> [NSManagedObject] {
        var items = [NSManagedObject]()
        if typeName.rawValue == "Item" {
            items = CoreDataManager.sharedInstance.fetchItems(with: typeName, predicate: NSPredicate(format: "parentCategory.title MATCHES %@", (selectedCategry?.title)!))
        } else {
           items = CoreDataManager.sharedInstance.fetchItems(with: typeName, predicate: nil)
        }
        
        let entityDescripter = NSEntityDescription.entity(forEntityName: typeName.rawValue, in: CoreDataManager.sharedInstance.context)

        let item = NSManagedObject(entity: entityDescripter!, insertInto: CoreDataManager.sharedInstance.context)
        
        item.setValue(tielText, forKey: "title")
        
        if let cat = selectedCategry {
            item.setValue(cat, forKey: "parentCategory")
        }
        items.append(item)
        
        saveItem()
        return items
    }
}
