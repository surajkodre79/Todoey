//
//  PopUpManager.swift
//  Todoey
//
//  Created by Suraj Kodre on 13/07/18.
//  Copyright © 2018 Suraj Kodre. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PopUpManager {
    
    func createPouUp(type: ManagedObjectType, selectedCategry: Category?, completion: @escaping ([NSManagedObject])->()) -> UIAlertController {
        var textField = UITextField()
        
        let popup = UIAlertController.init(title: "Add Item To List", message: "Please Enter Item", preferredStyle: .alert)
        popup.addTextField(configurationHandler: { (alertTextField) in
            alertTextField.placeholder = "Item"
            textField = alertTextField
        })
        popup.addAction(UIAlertAction.init(title: "Add", style: .default, handler: { (action) in
            if !(textField.text?.isEmpty)! {
                
                switch type {
                case .typeItem:
                    completion(CoreDataManager.sharedInstance.appendItemsOfType(typeName: .typeItem, tielText: textField.text!, selectedCategry: selectedCategry))
                
                case .typeCategory:
                    completion(CoreDataManager.sharedInstance.appendItemsOfType(typeName: .typeCategory, tielText: textField.text!, selectedCategry: nil))
                }
            }
        }))
        
        return popup
    }
}
