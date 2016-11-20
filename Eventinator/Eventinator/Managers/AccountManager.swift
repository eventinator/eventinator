//
//  AccountManager.swift
//  Lineup
//
//  Created by Evelio Tarazona on 11/20/16.
//  Copyright © 2016 Eventinator. All rights reserved.
//

import Foundation
import Parse

class AccountManager {
    static let shared = AccountManager()
    
    func hasUser() -> Bool {
        return PFUser.current() != nil
    }
    
    func logOut() {
        PFUser.logOut()
    }
}
