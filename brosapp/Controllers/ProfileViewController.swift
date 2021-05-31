//
//  ProfileViewController.swift
//  brosapp
//
//  Created by Shannon Brown on 2021-05-30.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let userEmail = user?.email {
            let docRef = db.collection("users").document(userEmail)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let property = document.get("Name") as! String
                    print(property)
                   
                    self.nameLabel.text = "Welcome back, \(property)"
//                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                    print("Document data: \(dataDescription)")
                    
                } else {
                    print("Document does not exist")
                    self.nameLabel.text = "Welcome back"
                }
            }
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
