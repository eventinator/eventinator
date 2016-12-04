//
//  AccountManager.swift
//  Lineup
//
//  Created by Evelio Tarazona on 11/20/16.
//  Copyright © 2016 Eventinator. All rights reserved.
//

import Foundation
import Parse
import ParseFacebookUtilsV4

class AccountManager {
    static let shared = AccountManager()
    
    var current: User? {
        get {
            guard hasUser() else {
                return nil
            }
            let user = PFUser.current()
            let facebookId = user?.object(forKey: "facebookId") as? String ?? "unknown"
            let profilePicUrlStr = user?.object(forKey: "profilePictureURL") as? String ?? "https://graph.facebook.com/\(facebookId)/picture?height=400"
            return User(
                id: user?.object(forKey: "id") as? String ?? "unknown",
                name: user?.object(forKey: "name") as? String ?? "",
                facebookId: facebookId,
                profilePictureURL: URL(string: profilePicUrlStr)
            )
        }
    }
    
    func update() {
        
        let user = PFUser.current()!
        
        guard PFFacebookUtils.isLinked(with: user) else {
            return
        }
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,name,email"])
        let connection = FBSDKGraphRequestConnection()
        connection.add(graphRequest) { _, result, error in
            guard result != nil, let result = result as? NSDictionary else {
                return
            }
            
            let facebookId = result["id"] as! String
            user.setValue(facebookId, forKey: "id")
            user.setValue(facebookId, forKey: "facebookId")
            user.setValue(result["name"] as? String ?? "", forKey: "name")
            user.setValue(result["email"] as? String ?? "", forKey: "email")
            user.saveInBackground()
            print("Got \(result)")
        }
        connection.start()
    }
    
    func hasUser() -> Bool {
        return PFUser.current() != nil
    }
    
    func logOut() {
        PFUser.logOut()
    }
}
