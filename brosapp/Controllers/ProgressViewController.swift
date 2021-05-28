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
        

        // Do any additional setup after loading the view.
    }
    
    func loadProgress() {
        db.collection("progress").addSnapshotListener { [self] (querySnapshot, error) in
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    
                    progressLength = []
                    for doc in snapshotDocuments {

                        let data = doc.data()
                        let currentTracker = trackerName!
                        
//                        print(data)
                        
                        if let userData = data["UserEmail"] {
                            let userEmailString = userData as! String
                            
                            if userEmailString == user?.email! {
                                if let trackerData = data["Tracker"] {
                                    let trackerDataString = trackerData as! String
                                    
                                    print("Tracker Name is: \(trackerDataString)")

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
    }
    
    

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        print("Add Button Pressed")
        
//        let currentTracker = trackerName!
//        print(currentTracker)
//        print("Cold Shower")
//        if currentTracker == "Cold Shower" {
//            print("It's a cold shower")
//        } else if currentTracker == "Pushup" {
//                        print("It's a pushup")
//                        performSegue(withIdentifier: "goToNumber", sender: self)
//        }

        
        
        if trackerName! == "Cold Shower" {
            print("It's a cold shower")
            performSegue(withIdentifier: "goToTimer", sender: self)
            
            
        } else if trackerName! == "Pushup" {
            print("It's a pushup")
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
            destinationVC.timerTrackerName = trackerName
        }
    }
    
     
    
}


//MARK: - UICollectionView DataSource & Delegate

extension ProgressViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("progress array length: \(progressLength.count)")
        return progressLength.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionCell.identifier, for: indexPath) as! ProgressCollectionCell
        cell.configure(with: progressLength[indexPath.row], with: cellDate)
        print(progressLength[indexPath.row])
        return cell
    }
    
    
}


////MARK: - UICollectionView DataSource & Delegate Methods
//
//extension ProgressViewController: UICollectionViewDataSource, UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return progressImages.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProgressCollectionViewCell.identifier, for: indexPath) as! ProgressCollectionViewCell
//
//        cell.configure(with: progressImages[indexPath.row])
//        return cell
//    }
//
//}
