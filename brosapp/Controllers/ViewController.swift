//
//  ViewController.swift
//  brosapp
//
//  Created by Shannon Brown on 2021-04-30.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet var googleButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 26
        loginButton.clipsToBounds = true
        registerButton.layer.cornerRadius = 26
        registerButton.clipsToBounds = true
        navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.isHidden = true
        GIDSignIn.sharedInstance().presentingViewController = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
         
    }
}

