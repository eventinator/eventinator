//
//  Event.swift
//  Lineup
//
//  Created by Evelio Tarazona on 11/12/16.
//  Copyright © 2016 Eventinator. All rights reserved.
//

import Foundation
import Parse

struct Event {
    let id: String
    let title: String
    let theDescription: String
    let start: Date?
    let end: Date?
    let locationId: String?
    let url: URL?
    let imageUrl: URL?
    let categoryId: String?
    let guestCount: UInt?
    let source: Source
    let location: Location?
    let tickets: [Ticket?]
    
    static func persistEvent(event: Event) {
        let user = PFUser.current()
        let username = user?.username
        
        let pfEvent = PFObject(className:"Event")
        pfEvent["username"] = username
        pfEvent["id"] = event.id
        pfEvent["title"] = event.title
        pfEvent["description"] = event.theDescription
        pfEvent["start"] = event.start
        pfEvent["end"] = event.end
        pfEvent["locationId"] = event.locationId
        pfEvent["url"] = event.url?.absoluteString
        pfEvent["imageUrl"] = event.imageUrl?.absoluteString
        pfEvent["categoryId"] = event.categoryId
        pfEvent["guestCount"] = event.guestCount
        
        let source = PFObject(className: "Source")
        source["eventId"] = event.source.eventId
        source["sourceId"] = event.source.sourceId
        source["source"] = event.source.source
        pfEvent["source"] = source
        
        pfEvent.saveInBackground(block: { (success: Bool, error: Error?) in
            if let error = error {
                NSLog("ERROR Persiting Event Save: \(error.localizedDescription)")
            }
            
            if success {
                NSLog("Successfully saved the user: \(user?.objectId) like event: \(event.id)")
            } else {
                NSLog("Error while saving user: \(user?.objectId) like event: \(error?.localizedDescription)")
            }
        })
    }
    
    static func fetchPersistedEvents(failure: ((Error) -> ())? = nil, success: @escaping ([Event]) -> ()) {
        let user = PFUser.current()
        let username = user?.username!
        
        let query = PFQuery(className:"Event")
        query.includeKey("source")
        query.whereKey("username", equalTo: username!)
        query.addDescendingOrder("createdAt")
        
        query.findObjectsInBackground { (result: [PFObject]?, error: Error?) in
            if let error = error {
                NSLog("Error while fetch likes for user: \(username!) error: \(error.localizedDescription)")
                if let failure = failure {
                    failure(error)
                }
            } else {
                if let objects = result {
                    var events = [Event]()
                    for object in objects {
                        let source = object.object(forKey: "source") as? PFObject
                        let eventId = source?.object(forKey: "eventId") as? String ?? ""
                        let sourceId = source?.object(forKey: "sourceId") as? String ?? ""
                        let sourceText = source?.object(forKey: "source") as? String ?? ""
                        
                        let querySource = Source(eventId: eventId, sourceId: sourceId, source: sourceText)
                        
                        let id = object.object(forKey: "id") as? String ?? ""
                        let title  = object.object(forKey: "title") as? String ?? ""
                        let description = object.object(forKey: "description") as? String ?? ""
                        let start = object.object(forKey: "start") as! Date
                        let end = object.object(forKey: "end") as! Date
                        let locationId  = object.object(forKey: "locationId") as? String ?? ""
                        let url  = URL(string: (object.object(forKey: "url") as! String))!
                        let imageUrl  = URL(string: (object["imageUrl"] as! String))!
                        let categoryId  = object.object(forKey: "categoryId") as? String ?? ""
                        let guestCount  = object.object(forKey: "guestCount") as? UInt ?? 0
                        
                        let fetchedEvent = Event(id: id, title: title, theDescription: description, start: start, end: end, locationId: locationId, url: url, imageUrl: imageUrl, categoryId: categoryId, guestCount: guestCount, source: querySource, location: nil, tickets: [Ticket]()
                        )
                        
                        events.append(fetchedEvent)
                    }
                    success(events)
                }
            }
        }
    }
}
