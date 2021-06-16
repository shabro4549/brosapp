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
//    var progressLength: [String] = []
//    var progressWeight: [String] = []
//    var progressReps: [String] = []
//    var progressSets: [String] = []
//    var cellDate = ""
//    var selectedCount = 0
//    var cellDatesArray: [String] = []
//    var datesOfClickedCell: [String] = []
    var progressCells: [Progress] = []

    
//    lazy var addBarButton: UIBarButtonItem = {
//        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:  #selector(readyToAdd(_:)))
//        return barButtonItem
//    }()
//
//    lazy var deleteBarButton: UIBarButtonItem = {
//        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(readyToDelete(_:)))
//        return barButtonItem
//    }()
    
    var selected : Set<IndexPath> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBarButton()
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
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        
        self.title = trackerName!
    }
    
    func setupBarButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(readyToAdd(_:)))
    }
    
    @objc func readyToAdd(_ sender: UIBarButtonItem) {
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
    
    @objc func readyToDelete(_ sender: UIBarButtonItem) {
        print("Ready to Delete Cell")
        
        var clickedProgressCells: [Progress] = []
        
        for progress in progressCells {
            if progress.selected == true {
                clickedProgressCells.append(progress)
            }
        }
        
        if trackingMetric! == "weight" {
            db.collection("weightProgress").getDocuments { (querySnapshot, error) in
                if let e = error {
                    print("there was an error retrieving documents to delete in trackers... \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            let trackerData = (data["TimeCreated"] as! NSNumber).stringValue
                            
                            for cell in clickedProgressCells {
                                if trackerData == cell.created {
                                        self.db.collection("weightProgress").document("\(doc.documentID)").delete()
                                    }
                                }
                        }
                        DispatchQueue.main.async() { [weak self] in
                                    self?.collectionView.reloadData()
                        }
                    }
                }
            }
        } else {
            print("Else statement in ready to delete")
            db.collection("progress").getDocuments { (querySnapshot, error) in
                if let e = error {
                    print("there was an error retrieving documents to delete in trackers... \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            let currentTracker = data["Tracker"] as! String
                            if currentTracker == self.trackerName! {
                                let trackerData = (data["TimeCreated"] as! NSNumber).stringValue
                                for cell in clickedProgressCells {
                                    if trackerData == cell.created {
                                            self.db.collection("progress").document("\(doc.documentID)").delete()
                                        }
                                }

                            }
                            
                            
                        }
                        DispatchQueue.main.async() { [weak self] in
                                    self?.collectionView.reloadData()
                        }
                    }
                }
            }
            
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(readyToAdd(_:)))
    }
    
   
    
    func loadProgress() {
        
        if trackingMetric == "weight" {
            
            db.collection("weightProgress").order(by: "TimeCreated").addSnapshotListener { [self] (querySnapshot, error) in
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        progressCells = []
                        
                        for doc in snapshotDocuments {
                            
                            let data = doc.data()
                            
                            if let userData = data["UserEmail"] {
                                let userEmailString = userData as! String
                                
                                if userEmailString == user?.email! {
                        
                                    let trackerWeight = data["Weight"] as! String
                                    let trackerReps = data["Reps"] as! String
                                    let trackerSets = data["Sets"] as! String
                                    let trackerDate = data["Date"] as! String
                                    let timeFromBeginning = (data["TimeCreated"] as! NSNumber).stringValue
                                    
                                    let newProgressCell = Progress(length: "", weight: trackerWeight, reps: trackerReps, sets: trackerSets, date: trackerDate, created: timeFromBeginning, selected: false)
                                    progressCells.append(newProgressCell)
                                    
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
                        progressCells = []
            
                        for doc in snapshotDocuments {

                            let data = doc.data()
                            let currentTracker = trackerName!

                            if let userData = data["UserEmail"] {
                                let userEmailString = userData as! String

                                if userEmailString == user?.email! {
                                    if let trackerData = data["Tracker"] {
                                        let trackerDataString = trackerData as! String

                                        if trackerDataString == currentTracker {
                                            
                                            if trackingMetric! == "number" {
                                                let trackerSessionLength = data["Number"] as! String
                                                let trackerDate = data["Date"] as! String
                                                let timeFromBeginning = (data["TimeCreated"] as! NSNumber).stringValue
                                                
                                                let newProgressCell = Progress(length: trackerSessionLength, weight: "", reps: "", sets: "", date: trackerDate, created: timeFromBeginning, selected: false)
                                                progressCells.append(newProgressCell)
                                            } else {
                                                let trackerSessionLength = data["LengthInSeconds"] as! String
                                                let trackerDate = data["Date"] as! String
                                                let timeFromBeginning = (data["TimeCreated"] as! NSNumber).stringValue
                                                
                                                let newProgressCell = Progress(length: trackerSessionLength, weight: "", reps: "", sets: "", date: trackerDate, created: timeFromBeginning, selected: false)
                                                progressCells.append(newProgressCell)
                                            }

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
        return progressCells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if trackingMetric! == "cold" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColdCollectionCell.identifier, for: indexPath) as! ColdCollectionCell
            cell.configure(with: progressCells[indexPath.row].length, with: progressCells[indexPath.row].date, with: progressCells[indexPath.row].created, with: progressCells[indexPath.row].selected)
            return cell
        } else if trackingMetric! == "weight" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionCell.identifier, for: indexPath) as! ProgressCollectionCell
            cell.configure(with: progressCells[indexPath.row].weight, with: progressCells[indexPath.row].reps, with: progressCells[indexPath.row].sets, with: progressCells[indexPath.row].date, with: progressCells[indexPath.row].created, with: progressCells[indexPath.row].selected)
            return cell
        } else if trackingMetric! == "number" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeNumberCollectionCell.identifier, for: indexPath) as! TimeNumberCollectionCell
            cell.configure(with: progressCells[indexPath.row].length, with: progressCells[indexPath.row].date, with: progressCells[indexPath.row].created, with: progressCells[indexPath.row].selected, with: trackingMetric!)
            return cell
        } else if trackingMetric! == "time" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeNumberCollectionCell.identifier, for: indexPath) as! TimeNumberCollectionCell
            cell.configure(with: progressCells[indexPath.row].length, with: progressCells[indexPath.row].date, with: progressCells[indexPath.row].created, with: progressCells[indexPath.row].selected, with: trackingMetric!)
            return cell
        } else if trackingMetric! == "breathe" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BreatheCollectionCell.identifier, for: indexPath) as! BreatheCollectionCell
            cell.configure(with: progressCells[indexPath.row].length, with: progressCells[indexPath.row].date, with: progressCells[indexPath.row].created, with: progressCells[indexPath.row].selected)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionCell.identifier, for: indexPath) as! ProgressCollectionCell
            cell.configure(with: progressCells[indexPath.row].weight, with: progressCells[indexPath.row].reps, with: progressCells[indexPath.row].reps, with: progressCells[indexPath.row].date, with: progressCells[indexPath.row].created, with: progressCells[indexPath.row].selected)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if progressCells[indexPath.row].selected == false {
            progressCells[indexPath.row].selected = true
            selected.insert(indexPath)
        } else {
            progressCells[indexPath.row].selected = false
            selected.remove(indexPath)
        }
        
        if selected.count != 0 {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(readyToDelete(_:)))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(readyToAdd(_:)))
        }
        
        collectionView.reloadData()
    }
    
    
}
