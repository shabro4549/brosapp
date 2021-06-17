//
//  GraphViewController.swift
//  brosapp
//
//  Created by Shannon Brown on 2021-06-17.
//

import UIKit
import Firebase

class GraphViewController: UIViewController {
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userEmail = user?.email {
            let docRef = db.collection("users").document(userEmail)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let property = document.get("Name") as! String
                    print(property)
                   
                    self.nameLabel.text = "Welcome back, \(property)"
            
                } else {
                    print("Document does not exist")
                    self.nameLabel.text = "Welcome back"
                }
            }
        }
        
        let font = UIFont.systemFont(ofSize: 12);
        signOutButton.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
                
                // This is to get the SceneDelegate object from your view controller
                // then call the change root view controller function to change to main tab bar
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
            self.performSegue(withIdentifier: "LogoutToMain", sender: self)
        } catch let signOutError as NSError {
            print("Error signing out ... \(signOutError)")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
