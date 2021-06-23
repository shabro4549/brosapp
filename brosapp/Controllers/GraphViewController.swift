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
    
    var usersTrackers: [Tracker] = []

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    @IBOutlet weak var graphTableView: UITableView!
    
    
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
        
        graphTableView.delegate = self
        graphTableView.dataSource = self
        graphTableView.register(UINib(nibName: "GraphCell", bundle: nil), forCellReuseIdentifier: "GraphCell")
        loadTrackers()
        let font = UIFont.systemFont(ofSize: 12);
        signOutButton.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)

    }
    
    func loadTrackers() {
        
        usersTrackers = []
        
        db.collection("trackers").addSnapshotListener { (querySnapshot, error) in
                self.usersTrackers = []

                if let e = error {
                    print("There was an issue retrieving tracker data from Firestore. \(e)")
                } else {
                    
                    if let snapshotDocuments = querySnapshot?.documents {
                        
                        for doc in snapshotDocuments {
    //                        print("This is the doc in snapshotListener for bigGoals ... \(doc.data())")
                            let data = doc.data()
                            
                            if let userData = data["user"] as? String, let trackerData = data["Name of Tracker"] as? String, let metricData = data["Tracking Metric"] as? String {
                                
                                let newTracker = Tracker(user: userData, trackerName: trackerData, trackingMetric: metricData)
                                
                                if let userEmail = self.user?.email {
                                    if newTracker.user == userEmail {
                                        self.usersTrackers.append(newTracker)
                                    }
                                }
                        
                                DispatchQueue.main.async {
                                    self.graphTableView.reloadData()
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
            
        }
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
    
}


//MARK: - TableView Delegate & DataSource

extension GraphViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersTrackers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = graphTableView.dequeueReusableCell(withIdentifier: "GraphCell", for: indexPath) as! GraphCell
        cell.configure(with: usersTrackers[indexPath.row].trackerName)
        return cell
    }
    
    
}

