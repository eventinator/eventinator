//
//  ParseLogInViewController.swift
//  Lineup
//
//  Created by Evelio Tarazona on 11/20/16.
//  Copyright © 2016 Eventinator. All rights reserved.
//

import Foundation
import ParseUI

class ParseSignUpViewController : PFSignUpViewController, PFSignUpViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self

        signUpView?.tintColor = Colors.branding
        signUpView?.logo = UIImageView(image: UIImage(named: "lineup-logo-full")!)
        signUpView?.logo?.contentMode = .scaleAspectFit
        signUpView?.backgroundColor = Colors.background
    }
    
    
    func signUpViewController(_ signUpController: PFSignUpViewController, didSignUp user: PFUser) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        self.present(mainViewController, animated: true, completion: nil)
    }
}
