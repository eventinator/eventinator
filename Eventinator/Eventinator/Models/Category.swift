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
    
    private static func createPFCategory(_ category: Category) -> PFObject? {
        guard let user = PFUser.current() else {
            return nil
        }
        let username = user.username!
        
        let pfCategory = PFObject(className:"Category")
        pfCategory["username"] = username
        pfCategory["id"] = category.id
        pfCategory["name"] = category.name
        return pfCategory
    }
    
    private static func createPFQuery() -> PFQuery<PFObject>? {
        guard let user = PFUser.current() else {
            return nil
        }
        
        let username = user.username!
        let query = PFQuery(className:"Category")
        query.whereKey("username", equalTo: username)
        return query
    }
    
    static func persist(_ category: Category) {
        let pfCategory = createPFCategory(category)
        pfCategory?.saveInBackground { (success, error) in
            if success {
                print("Successfully saved category: \(category.id)")
            } else {
                print("Error while saving category: \(category.id) got \(error?.localizedDescription)")
            }
        }
    }
    
    static func remove(_ category: Category) {
        let query = createPFQuery()!
        query.whereKey("id", equalTo: category.id)
        query.findObjectsInBackground { (objects, _) in
            guard let objects = objects else {
                return
            }
            for obj in objects {
                print("Removing \(obj)")
                obj.deleteInBackground()
            }
        }
    }
    
    static func fetchPersistedCategories(failure: ((Error) -> ())? = nil, success: @escaping ([Category]) -> ()) {
        let query = createPFQuery()!
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
            if let error = error {
                print("Error while fetching categories error: \(error.localizedDescription)")
                if let failure = failure {
                    failure(error)
                }
            } else {
                if let objects = objects {
                    var categories = [Category]()
                    for object in objects {
                        let id = object.object(forKey: "id") as? String ?? ""
                        let name = object.object(forKey: "name") as? String ?? ""
                        
                        let fetchedCategory = Category(id: id, name: name)
                        
                        categories.append(fetchedCategory)
                    }
                    success(categories)
                }
            }
        })
    }
}
