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
    
    static func persistCategory(category: Category) {
        let user = PFUser.current()
        let username = user?.username
        
        let pfCategory = PFObject(className:"Category")
        pfCategory["username"] = username
        pfCategory["id"] = category.id
        pfCategory["name"] = category.name
        
        pfCategory.saveInBackground(block: { (success: Bool, error: Error?) in
            if success {
                NSLog("Successfully saved the user: \(user?.objectId) like category: \(category.id)")
            } else {
                NSLog("Error while saving user: \(user?.objectId) like category: \(error?.localizedDescription)")
            }
        })
    }
    
    static func fetchPersistedCategories(failure: ((Error) -> ())? = nil, success: @escaping ([Category]) -> ()) {
        let user = PFUser.current()
        let username = user?.username!
        
        let query = PFQuery(className:"Category")
        query.whereKey("username", equalTo: username!)
        query.addDescendingOrder("createdAt")
        
        query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
            if let error = error {
                NSLog("Error while fetching categories for user: \(user?.objectId) error: \(error.localizedDescription)")
                if let failure = failure {
                    failure(error)
                }
            } else {
                if let objects = objects {
                    var categories = [Category]()
                    for object in objects {
                        let id = object.object(forKey: "id") as? String ?? ""
                        let name  = object.object(forKey: "name") as? String ?? ""
                        
                        let fetchedCategory = Category(id: id, name: name)
                        
                        categories.append(fetchedCategory)
                    }
                    success(categories)
                }
            }
        })
    }
}
