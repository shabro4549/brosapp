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
    @IBOutlet weak var tableView: UITableView!
    var usersTrackers: [Tracker] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ResultsCell", bundle: nil), forCellReuseIdentifier: "ResultsCell")
        
        loadTrackersResults()

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
        
    }
    
    func loadTrackersResults() {
        usersTrackers = []
        
        db.collection("trackers").addSnapshotListener { (querySnapshot, error) in
                self.usersTrackers = []

                if let e = error {
                    print("There was an issue retrieving tracker data from Firestore. \(e)")
                } else {
                    
                    if let snapshotDocuments = querySnapshot?.documents {
                        
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            
                            if let userData = data["user"] as? String, let trackerData = data["Name of Tracker"] as? String, let metricData = data["Tracking Metric"] as? String {
                                
                                let newTracker = Tracker(user: userData, trackerName: trackerData, trackingMetric: metricData)
                                
                                if let userEmail = self.user?.email {
                                    if newTracker.user == userEmail {
                                        self.usersTrackers.append(newTracker)
                                    }
                                }
                        
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    
                                }
                                
                            }
                            
                        }
                        
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

//MARK: - TableView Delegate

extension ProfileViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersTrackers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultsCell", for: indexPath) as! ResultsCell
        cell.configure(with: usersTrackers[indexPath.row].trackerName)
        return cell
    }
    
    
}

