//
//  ProgressViewController.swift
//  brosapp
//
//  Created by Shannon Brown on 2021-05-17.
//

import UIKit
import Firebase

class ProgressViewController: UIViewController {
    
    var trackerName: String?
    var trackingMetric: String?
    var user = Auth.auth().currentUser
    let db = Firestore.firestore()
    @IBOutlet weak var collectionView: UICollectionView!
    var progressLength: [String] = []
    var progressWeight: [String] = []
    var progressReps: [String] = []
    var progressSets: [String] = []
    var cellDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Tracking metric with progress controller = \(trackingMetric!)")
        loadProgress()
        
        if trackingMetric == "cold" {
            let nib = UINib(nibName: ColdCollectionCell.identifier, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: ColdCollectionCell.identifier)
        } else if trackingMetric == "breathe"{
            let nib = UINib(nibName: BreatheCollectionCell.identifier, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: BreatheCollectionCell.identifier)
        } else if trackingMetric == "time"{
            let nib = UINib(nibName: TimeNumberCollectionCell.identifier, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: TimeNumberCollectionCell.identifier)
        } else if trackingMetric == "number" {
            let nib = UINib(nibName: TimeNumberCollectionCell.identifier, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: TimeNumberCollectionCell.identifier)
        } else {
            let nib = UINib(nibName: ProgressCollectionCell.identifier, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: ProgressCollectionCell.identifier)
        }
        

        collectionView.dataSource = self
        collectionView.delegate = self
        
//        print(trackerName!)
        self.title = trackerName!
    }
    
    func loadProgress() {
        
        
        if trackingMetric == "weight" {
            
            db.collection("weightProgress").order(by: "TimeCreated").addSnapshotListener { [self] (querySnapshot, error) in
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        progressWeight = []
                        
                        for doc in snapshotDocuments {
                            
                            let data = doc.data()
//                            let currentTracker = trackerName!
                            
                            if let userData = data["UserEmail"] {
                                let userEmailString = userData as! String
                                
                                if userEmailString == user?.email! {
                                    
                                    let trackerWeight = data["Weight"] as! String
                                    let trackerReps = data["Reps"] as! String
                                    let trackerSets = data["Sets"] as! String
                                    let trackerDate = data["Date"] as! String
                                    
//                                    print(trackerWeight)
                                    cellDate = trackerDate
                                    progressWeight.append(trackerWeight)
                                    progressReps.append(trackerReps)
                                    progressSets.append(trackerSets)
//                                    print(progressWeight)
                                   
                                }
                                DispatchQueue.main.async() { [weak self] in
                                            self?.collectionView.reloadData()
                                        }
                            }
                            
                        }
                        
                    }
                }
            }
            
        } else {

            db.collection("progress").order(by: "TimeCreated").addSnapshotListener { [self] (querySnapshot, error) in
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {

                        progressLength = []
                        for doc in snapshotDocuments {

                            let data = doc.data()
                            let currentTracker = trackerName!

                            if let userData = data["UserEmail"] {
                                let userEmailString = userData as! String

                                if userEmailString == user?.email! {
                                    if let trackerData = data["Tracker"] {
                                        let trackerDataString = trackerData as! String

//                                        if trackerDataString == "Cold Shower" {
//
//                                        } else if trackerDataString == "Pushup" {
//                                        }
                                        if trackerDataString == currentTracker {
                                            
                                            if trackingMetric! == "number" {
                                                let trackerSessionLength = data["Number"] as! String
                                                progressLength.append(trackerSessionLength)
                                            } else {
                                                let trackerSessionLength = data["LengthInSeconds"] as! String
                                                progressLength.append(trackerSessionLength)
                                            }
                                            
                                            let trackerDate = data["Date"] as! String
                                            cellDate = trackerDate
                                            

                                        }

                                        DispatchQueue.main.async() { [weak self] in
                                                    self?.collectionView.reloadData()
                                                }

                                    }

                                }
                            }

                        }

                    }
                }

            }
        }
    }
    
    

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        if trackingMetric! == "cold" {
            performSegue(withIdentifier: "goToCold", sender: self)
        } else if trackingMetric! == "weight" {
            performSegue(withIdentifier: "goToWeight", sender: self)
        } else if trackingMetric! == "breathe" {
            performSegue(withIdentifier: "goToBreathe", sender: self)
        } else if trackingMetric! == "number" {
            performSegue(withIdentifier: "goToNumber", sender: self)
        } else if trackingMetric! == "time" {
            performSegue(withIdentifier: "goToTimer", sender: self)
        }
    
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if trackingMetric! == "cold" {
            let destinationVC = segue.destination as! ColdViewController
            destinationVC.trackerTitle = trackerName
        } else if trackingMetric! == "weight" {
            let destinationVC = segue.destination as! WeightViewController
            destinationVC.trackerTitle = trackerName
        } else if trackingMetric! == "breathe" {
            let destinationVC = segue.destination as! BreatheViewController
            destinationVC.trackerTitle = trackerName
        } else if trackingMetric! == "number" {
            let destinationVC = segue.destination as! NumberViewController
            destinationVC.trackerTitle = trackerName
        } else if trackingMetric! == "time" {
            let destinationVC = segue.destination as! TimerViewController
            destinationVC.trackerTitle = trackerName
        }
    }
    
     
    
}


//MARK: - UICollectionView DataSource & Delegate

extension ProgressViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if trackingMetric! == "cold" {
            return progressLength.count
        } else if trackingMetric! == "weight" {
            return progressWeight.count
        } else {
            return progressLength.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if trackingMetric! == "cold" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColdCollectionCell.identifier, for: indexPath) as! ColdCollectionCell
            cell.configure(with: progressLength[indexPath.row], with: cellDate, with: trackerName!)
            return cell
        } else if trackingMetric! == "weight" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionCell.identifier, for: indexPath) as! ProgressCollectionCell
            cell.configure(with: progressWeight[indexPath.row], with: progressReps[indexPath.row], with: progressSets[indexPath.row], with: cellDate, with: trackerName!)
            return cell
        } else if trackingMetric! == "number" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeNumberCollectionCell.identifier, for: indexPath) as! TimeNumberCollectionCell
            cell.configure(with: progressLength[indexPath.row], with: cellDate, with: trackerName!, with: trackingMetric!)
            return cell
        } else if trackingMetric! == "time" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeNumberCollectionCell.identifier, for: indexPath) as! TimeNumberCollectionCell
            cell.configure(with: progressLength[indexPath.row], with: cellDate, with: trackerName!, with: trackingMetric!)
            return cell
        } else if trackingMetric! == "breathe" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BreatheCollectionCell.identifier, for: indexPath) as! BreatheCollectionCell
            cell.configure(with: progressLength[indexPath.row], with: cellDate, with: trackerName!)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionCell.identifier, for: indexPath) as! ProgressCollectionCell
            cell.configure(with: progressWeight[indexPath.row], with: progressReps[indexPath.row], with: progressSets[indexPath.row], with: cellDate, with: trackerName!)
            return cell
        }
    }

    
    
}
