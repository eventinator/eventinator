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
        EventbriteClient.shared.events(failure: failure, success: success)
    }
}
