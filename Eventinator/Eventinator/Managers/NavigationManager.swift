//
//  NavigationManager.swift
//  Lineup
//
//  Created by Evelio Tarazona on 11/20/16.
//  Copyright © 2016 Eventinator. All rights reserved.
//

import Foundation
import UIKit
import Parse

class NavigationManager {
    static let shared = NavigationManager()
    
    private var mainStoryboard: UIStoryboard {
        get {
            return UIStoryboard(name: "Main", bundle: nil)
        }
    }
    
    func rootViewController() -> UIViewController {
        let hasUser = AccountManager.shared.hasUser()
        return hasUser ? mainViewController() : defaultViewController()
    }
    
    func toMain(from: UIViewController) {
        from.present(mainViewController(), animated: true, completion: nil)
    }
    
    private func defaultViewController() -> UIViewController {
        return mainStoryboard.instantiateInitialViewController()!
    }
    
    private func mainViewController() -> UIViewController {
        return mainStoryboard.instantiateViewController(withIdentifier: "MainViewController")
    }
}
  
