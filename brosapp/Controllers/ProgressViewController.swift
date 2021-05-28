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
        
        loadProgress()
        
        let nib = UINib(nibName: ProgressCollectionCell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: ProgressCollectionCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        print(trackerName!)
        self.title = trackerName!
    }
    
    func loadProgress() {
        
        if trackerName == "Cold Shower" {
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

                                        if trackerDataString == currentTracker {
                                            let trackerSessionLength = data["LengthInSeconds"] as! String
                                            let trackerDate = data["Date"] as! String

                                            cellDate = trackerDate
                                            progressLength.append(trackerSessionLength)

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
        } else if trackerName == "Pushup" {
            print("loadProgress has correctly read as Pushup and should be working on loading")
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
                                    
                                    print(trackerWeight)
                                    cellDate = trackerDate
                                    progressWeight.append(trackerWeight)
                                    progressReps.append(trackerReps)
                                    progressSets.append(trackerSets)
                                    print(progressWeight)
                                   
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
    
    

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        if trackerName! == "Cold Shower" {
//            print("It's a cold shower")
            performSegue(withIdentifier: "goToTimer", sender: self)
            
            
        } else if trackerName! == "Pushup" {
//            print("It's a pushup")
            performSegue(withIdentifier: "goToNumber", sender: self)
//            func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//               let destinationVC = segue.destination as! TimerViewController
//               destinationVC.trackerName = trackerName
//           }
        }
    
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if trackerName! == "Cold Shower" {
            let destinationVC = segue.destination as! TimerViewController
            destinationVC.timerTrackerName = trackerName
        } else if trackerName! == "Pushup" {
            let destinationVC = segue.destination as! NumberViewController
            destinationVC.numberTrackerName = trackerName
        }
    }
    
     
    
}


//MARK: - UICollectionView DataSource & Delegate

extension ProgressViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if trackerName! == "Cold Shower" {
            return progressLength.count
        } else if trackerName! == "Pushup" {
            print("The collection view correctly reads as Pushup and returns progress weight")
            return progressWeight.count
        } else {
            return progressWeight.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if trackerName! == "Cold Shower" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionCell.identifier, for: indexPath) as! ProgressCollectionCell
            cell.configure(with: progressLength[indexPath.row], with: "n/a", with: "n/a", with: cellDate, with: trackerName!)
            return cell
        } else if trackerName! == "Pushup" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionCell.identifier, for: indexPath) as! ProgressCollectionCell
            print(progressWeight[indexPath.row])
            cell.configure(with: progressWeight[indexPath.row], with: progressReps[indexPath.row], with: progressSets[indexPath.row], with: cellDate, with: trackerName!)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionCell.identifier, for: indexPath) as! ProgressCollectionCell
            print(progressWeight[indexPath.row])
            cell.configure(with: progressWeight[indexPath.row], with: progressReps[indexPath.row], with: progressSets[indexPath.row], with: cellDate, with: trackerName!)
            return cell
        }
    }
    
    
}
