//
//  RegisterViewController.swift
//  brosapp
//
//  Created by Shannon Brown on 2021-05-03.
//

import UIKit
import Firebase


class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var feedbackLabel: UILabel!

    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        

        nameTextField.delegate = self
        nameTextField.tag = 1
        emailTextField.delegate = self
        emailTextField.tag = 2
        passwordTextField.delegate = self
        passwordTextField.tag = 3
        
        registerButton.layer.cornerRadius = registerButton.frame.height/2
        registerButton.clipsToBounds = true
        self.tabBarController?.tabBar.isHidden = true
        feedbackLabel.alpha = 0
    }
    @IBAction func registerPressed(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            if password.count < 6 {
                feedbackLabel.alpha = 1
                feedbackLabel.text = "Password must be more than 6 characters"
            }
            if nameTextField.text == "" {
                nameTextField.placeholder = "Please enter name"
            }
            if emailTextField.text == "" {
                emailTextField.placeholder = "Please enter an email"
            }
            if passwordTextField.text == "" {
                passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password Required", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            }
            
            if password.count > 6 && nameTextField.text != "" && emailTextField.text != "" && passwordTextField.text != "" {
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let e = error {
                        print(e)
                        self.feedbackLabel.alpha = 1
                        self.feedbackLabel.text = "Something went wrong, check email"
                    } else {
                        self.db.collection("users").document(self.emailTextField.text!).setData([
                            "Name" : self.nameTextField.text!,
                            "Email" : self.emailTextField.text!
                        ])
                        self.performSegue(withIdentifier: "RegisterToAccount", sender: self)
                        
                    }
                }
                
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1
        {
            nameTextField.endEditing(true)
            return true
        } else if textField.tag == 2
        {
            emailTextField.endEditing(true)
            return true
        } else {
            passwordTextField.endEditing(true)
            return true
        }
    }

}
