//
//  LineupClient.swift
//  Lineup
//
//  Created by Evelio Tarazona on 11/12/16.
//  Copyright © 2016 Eventinator. All rights reserved.
//

import Foundation


public class LineupClient {
    static let shared = LineupClient()
    
    func events(failure: ((Error) -> ())? = nil, success: @escaping ([Event]) -> ()) {
        Category.fetchPersistedCategories(failure: { error in
            print("Unable to fetch categories \(error)")
            EventbriteClient.shared.events(failure: failure, success: success)
        }) { categories in
            print("Using categories \(categories)")
            EventbriteClient.shared.events(categories: categories, failure: failure, success: success)
        }
        
    }
    
    // TODO(MIKE)
    // Fetch all events specific to the category preferences of the user
    func eventsDiscoverForUser(failure: ((Error) -> ())? = nil, success: @escaping ([Event]) -> ()) {
        //        Category.fetchPersistedCategories(failure: failure, success: success)
        
        //        Category.fetchPersistedCategories(failure: failure, success: success)
        //        EventbriteClient.shared.events(userCategories, failure: failure, success: success)
        //        Event.fetchPersistedEvents(failure: failure, success: success)
        //        EventbriteClient.shared.userSavedEvents(failure: failure, success: success)
        
        EventbriteClient.shared.events(failure: failure, success: success)
    }

    func eventsSavedForUser(failure: ((Error) -> ())? = nil, success: @escaping ([Event]) -> ()) {
        Event.fetchPersistedEvents(failure: failure, success: success)
    }
    
    func userCategories(failure: ((Error) -> ())? = nil, success: @escaping ([Category]) -> ()) {
        Category.fetchPersistedCategories(failure: failure, success: success)
    }
}
