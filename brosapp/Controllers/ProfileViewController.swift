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
    var trackerProgress: [Float] = []
    var lowestProgress: Float = 0
    var highestProgress: Float = 0
    var avgProgress: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ResultsCell", bundle: nil), forCellReuseIdentifier: "ResultsCell")
        
        loadTrackersResults()
        lowestToHighest()
        
        

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
        
//        print(trackerProgress)
        
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
    
    func lowestToHighest() {
//        db.collection("progress").addSnapshotListener { [self] (querySnapshot, error) in
//            if let e = error {
//                print("There was an issue retrieving data from Firestore. \(e)")
//            } else {
//                if let snapshotDocuments = querySnapshot?.documents {
//                    trackerProgress = []
//
//                    for doc in snapshotDocuments {
//
//                        let data = doc.data()
//                        let currentTracker = "Breathe"
//
//                        if let userData = data["UserEmail"] {
//                            let userEmailString = userData as! String
//
//                            if userEmailString == user?.email! {
//                                if let trackerData = data["Tracker"] {
//                                    let trackerDataString = trackerData as! String
//
//                                    if trackerDataString == currentTracker {
//                                        let trackerSessionLength = data["LengthInSeconds"] as! String
//                                        print(Float(trackerSessionLength))
//                                        trackerProgress.append(Float(trackerSessionLength)!)
//
//                                    }
//
//                                }
//
//                            }
//                        }
//
//                    }
//
//                    highestProgress = trackerProgress.max()!
//                    lowestProgress = trackerProgress.min()!
//                    let sumArray = trackerProgress.reduce(0, +)
//                    let count = Float(trackerProgress.count)
//                    avgProgress = sumArray/count
//
//
//                }
//            }
//
//        }
        
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
        
        if usersTrackers[indexPath.row].trackingMetric == "weight" {
            db.collection("weightProgress").addSnapshotListener { [self] (querySnapshot, error) in
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        trackerProgress = []
            
                        for doc in snapshotDocuments {

                            let data = doc.data()
                            let currentTracker = usersTrackers[indexPath.row].trackerName

                            if let userData = data["UserEmail"] {
                                let userEmailString = userData as! String

                                if userEmailString == user?.email! {
                                    if let trackerData = data["Tracker"] {
                                        let trackerDataString = trackerData as! String

                                        if trackerDataString == currentTracker {
                                            
                                            let trackerReps = data["Reps"] as! String
                                            let trackerSets = data["Sets"] as! String
                                            let trackerWeights = data["Weight"] as! String
                                            let total = Float(trackerReps)! * Float(trackerSets)! * Float(trackerWeights)!
                                            trackerProgress.append(Float(total))
                                        }

                                    }

                                }
                            }

                        }
                        
                        highestProgress = trackerProgress.max()!
                        lowestProgress = trackerProgress.min()!
                        let sumArray = trackerProgress.reduce(0, +)
                        let count = Float(trackerProgress.count)
                        avgProgress = sumArray/count
                        let isWeight = true
                        cell.configure(with: usersTrackers[indexPath.row].trackerName, with: highestProgress, with: lowestProgress, with: avgProgress, with: isWeight)
                        

                    }
                }

            }
        } else {
            db.collection("progress").addSnapshotListener { [self] (querySnapshot, error) in
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        trackerProgress = []
            
                        for doc in snapshotDocuments {

                            let data = doc.data()
                            let currentTracker = usersTrackers[indexPath.row].trackerName
                            let currentTrackerMetric = usersTrackers[indexPath.row].trackingMetric

                            if let userData = data["UserEmail"] {
                                let userEmailString = userData as! String

                                if userEmailString == user?.email! {
                                    if let trackerData = data["Tracker"] {
                                        let trackerDataString = trackerData as! String

                                        if trackerDataString == currentTracker {
                                            print(currentTrackerMetric)
                                            if currentTrackerMetric == "breathe" || currentTrackerMetric == "cold" {
                                                print("equals")
                                                let trackerSessionLength = data["LengthInSeconds"] as! String
                                                trackerProgress.append(Float(trackerSessionLength)!)
                                                print(trackerProgress)
                                            } else if currentTrackerMetric == "number" {
                                                let trackerSessionLength = data["Number"] as! String
                                                trackerProgress.append(Float(trackerSessionLength)!)
                                                print(trackerProgress)
                                            } else {
                                                let trackerSessionLength = data["LengthInSeconds"] as! String
                                                trackerProgress.append(Float(trackerSessionLength)!)
                                                print(Float(trackerSessionLength))
                                            }
                                            

                                        }

                                    }

                                }
                            }

                        }
                        
                        highestProgress = trackerProgress.max()!
                        lowestProgress = trackerProgress.min()!
                        let sumArray = trackerProgress.reduce(0, +)
                        let count = Float(trackerProgress.count)
                        avgProgress = sumArray/count
                        let isWeight = false
                        cell.configure(with: usersTrackers[indexPath.row].trackerName, with: highestProgress, with: lowestProgress, with: avgProgress, with: isWeight)
                        

                    }
                }

            }
        }
        
        
       
        return cell
    }
    
    
}

