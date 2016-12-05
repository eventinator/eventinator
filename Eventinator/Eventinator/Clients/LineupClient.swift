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
    
    func eventsDiscoverForUser(failure: ((Error) -> ())? = nil, success: @escaping ([Event]) -> ()) {
        EventbriteClient.shared.events(failure: failure, success: success)
    }

    func eventsSavedForUser(failure: ((Error) -> ())? = nil, success: @escaping ([Event]) -> ()) {
        Event.fetchPersistedEvents(failure: failure, success: success)
    }
    
    func userCategories(failure: ((Error) -> ())? = nil, success: @escaping ([Category]) -> ()) {
        Category.fetchPersistedCategories(failure: failure, success: success)
    }
}
