//
//  LoginViewController.swift
//  brosapp
//
//  Created by Shannon Brown on 2021-05-03.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    
    @IBAction func loginPressed(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                if let e = error {
                    print(e)
                } else {
                    self.performSegue(withIdentifier: "LoginToAccount", sender: self)
                }
            }
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "AccountTabBarController")
            
            // This is to get the SceneDelegate object from your view controller
            // then call the change root view controller function to change to main tab bar
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        
    }
    
}
