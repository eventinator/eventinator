//
//  ParseLogInViewController.swift
//  Lineup
//
//  Created by Evelio Tarazona on 11/20/16.
//  Copyright © 2016 Eventinator. All rights reserved.
//

import Foundation
import ParseUI

class ParseLoginViewController : PFLogInViewController, PFLogInViewControllerDelegate {

    override func viewDidLoad() {
        delegate = self
        
        signUpController = ParseSignUpViewController()
        fields = [.facebook, .usernameAndPassword, .logInButton, .signUpButton, .passwordForgotten]
        facebookPermissions = ["public_profile", "email", "user_events"]

        super.viewDidLoad()

        logInView?.tintColor = Colors.branding
        logInView?.logo = UIImageView(image: UIImage(named: "lineup-logo-full")!)
        logInView?.logo?.contentMode = .scaleAspectFit
        logInView?.backgroundColor = Colors.background
    }
    
    func log(_ logInController: PFLogInViewController, didLogIn user: PFUser) {
        NavigationManager.shared.toMain(from: self)
    }
    
}
