//
//  ViewController.swift
//  brosapp
//
//  Created by Shannon Brown on 2021-04-30.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = loginButton.frame.height/2
        loginButton.clipsToBounds = true
        registerButton.layer.cornerRadius = registerButton.frame.height/2
        registerButton.clipsToBounds = true
        navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
         
    }
}

