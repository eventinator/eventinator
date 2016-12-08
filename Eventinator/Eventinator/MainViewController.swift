//
//  MainController.swift
//  Lineup
//
//  Created by Jon O'Keefe on 11/13/16.
//  Copyright © 2016 Eventinator. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
}

protocol LoadableController {
    
    func loadIfNeeded()
}

extension MainViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        guard let navController = viewController as? UINavigationController else {
            return
        }
        
        guard let loadable = navController.topViewController as? LoadableController else {
            return
        }
        
        loadable.loadIfNeeded()
    }
}
