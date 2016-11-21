//
//  AppDelegate.swift
//  Eventinator
//
//  Created by Evelio Tarazona on 11/4/16.
//  Copyright © 2016 Eventinator. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Parse.initialize(with:
            ParseClientConfiguration(block: { (configuration:ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "lineupcodepath"
                configuration.clientKey = nil  // set to nil assuming you have not set clientKey. Master Key is set as an Environment Variable
                configuration.server = "https://lineupcodepath.herokuapp.com/parse"
            })
        )
        PFFacebookUtils.initializeFacebook(applicationLaunchOptions: launchOptions)
        
        // Set the styling for page control dots in onboarding
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = Colors.branding
        pageControl.backgroundColor = Colors.background
        
        window?.rootViewController = NavigationManager.shared.rootViewController()
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
    }
}

