//
//  RegisterViewController.swift
//  brosapp
//
//  Created by Shannon Brown on 2021-05-03.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let db = Firestore.firestore()
    
    @IBAction func registerPressed(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                } else {
                    self.performSegue(withIdentifier: "RegisterToAccount", sender: self)
                    
                }
            }
            
        }
        
        db.collection("users").addDocument(data: [
            "Name" : nameTextField.text!,
            "Email" : emailTextField.text!
        ])
        
    }

}
