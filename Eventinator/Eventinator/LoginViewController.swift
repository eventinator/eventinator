//
//  LoginViewController.swift
//  Lineup
//
//  Created by Jon O'Keefe on 11/13/16.
//  Copyright © 2016 Eventinator. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func onLoginClick(_ sender: Any) {
        // Verify that the user is valid
        let user = PFUser()
        user.username = usernameTextField.text!
        user.password = passwordTextField.text!
        
        PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!)
        { (pfUser:PFUser?, error:Error?) in
            if let error = error {
                dump(error)
                let alert = UIAlertAction(title: "OK", style: .default, handler: nil)
                let alertController = UIAlertController(title: "Log in Error", message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(alert)
                self.present(alertController, animated: true, completion: nil)
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
                self.present(mainViewController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func onSignupTap(_ sender: Any) {
        let user = PFUser()
        user.username = usernameTextField.text!
        user.password = passwordTextField.text!
        
        user.signUpInBackground { (succeeded: Bool, error: Error?) in
            if let error = error {
                let alert = UIAlertAction(title: "OK", style: .default, handler: nil)
                let alertController = UIAlertController(title: "Sign up Error", message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(alert)
                self.present(alertController, animated: true, completion: nil)
            } else {
                let alert = UIAlertAction(title: "OK", style: .default, handler: nil)
                let alertController = UIAlertController(title: "Sign Up Successful", message: "You signed up for an account successfully!", preferredStyle: .alert)
                alertController.addAction(alert)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
