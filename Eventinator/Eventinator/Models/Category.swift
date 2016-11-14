//
//  Category.swift
//  Lineup
//
//  Created by Evelio Tarazona on 11/12/16.
//  Copyright © 2016 Eventinator. All rights reserved.
//

import Foundation
import Parse

struct Category {
    let id: String
    let name: String
}

func persistCategory(category: Category) {
    let user = PFUser.current()
    
    let pfCategory = PFObject(className:"Category")
    pfCategory["id"] = category.id
    pfCategory["name"] = category.name
    
    let relation = user?.relation(forKey: "categories")
    relation?.add(pfCategory)
    
    user?.saveInBackground(block: { (success: Bool, error: Error?) in
        if (success) {
            NSLog("Successfully saved the user: \(user?.objectId) like category: \(category.id)")
        } else {
            NSLog("Error while saving user: \(user?.objectId) like category: \(error?.localizedDescription)")
        }
    })
}

func fetchPersistedCategories(user: User) -> [Category] {
    let user = PFUser.current()
    let relation = user?.relation(forKey: "categories")
    let query = relation?.query()
    
    var categories = [Category]()
    
    query?.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
        if let error = error {
            NSLog("Error while fetching categories for user: \(user?.objectId) error: \(error.localizedDescription)")
        } else {
            if let objects = objects {
                for object in objects {
                    let id = object.object(forKey: "id") as? String ?? ""
                    let name  = object.object(forKey: "name") as? String ?? ""
                    
                    let fetchedCategory = Category(id: id, name: name)
                    
                    categories.append(fetchedCategory)
                }
            }
        }
        
    })
    return categories
}


