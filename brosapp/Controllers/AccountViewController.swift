//
//  AccountViewController.swift
//  brosapp
//
//  Created by Shannon Brown on 2021-05-03.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {
    
    var user = Auth.auth().currentUser
    var usersTrackers: [Tracker] = []
    var selectedTracker = "" 
    let db = Firestore.firestore()
    @IBOutlet weak var trackerTableView: UITableView!
    let customAlert = CreateTrackerAlert()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trackerTableView.delegate = self
        trackerTableView.dataSource = self
        trackerTableView.register(UINib(nibName: "TrackerCell", bundle: nil), forCellReuseIdentifier: "TrackerCell")
        loadTrackers()
        
//        let docRef = db.collection("trackers").document(user?.email!)
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
                                    self.trackerTableView.reloadData()
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
            
        }
    }
    
    @IBAction func addTrackerPressed(_ sender: Any) {
        customAlert.showAlert(with: "Add a Tracker", message: "Add something you'd like to track", on: self)
    }
    

}

//MARK: - TableView Delegate & DataSource

extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersTrackers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = trackerTableView.dequeueReusableCell(withIdentifier: "TrackerCell", for: indexPath) as! TrackerCell
        cell.delegate = self
        cell.configure(with: usersTrackers[indexPath.row].trackerName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let currentTrackerName = usersTrackers[indexPath.row].trackerName
        if editingStyle == .delete {

            db.collection("progress").getDocuments { (querySnapshot, error) in
                if let e = error {
                    print("there was an error retrieving documents to delete in trackers... \(e)")
                } else {
                    
                    if let snapshotDocuments = querySnapshot?.documents {
                        
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let trackerData = data["Tracker"] as? String {
                                if trackerData == currentTrackerName {
                                    self.db.collection("progress").document("\(doc.documentID)").delete()
                                }
                            }
                            
                        }
                        
                    }


                }
            }
            
            db.collection("trackers").getDocuments { (querySnapshot, error) in
                if let e = error {
                    print("there was an error retrieving documents to delete in trackers... \(e)")
                } else {
                    
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            
                            let data = doc.data()
                            
                            if let trackerData = data["Name of Tracker"] as? String {
                                if trackerData == self.usersTrackers[indexPath.row].trackerName {
                                    self.db.collection("trackers").document("\(doc.documentID)").delete()
                                }
                            }
                            
                        }
                        
                    }


                }
            }
            
        }
    }
}


//MARK: - TableViewCell Delegate

extension AccountViewController: TrackerCellDelegate {
    func didTapButton(with title: String) {
        selectedTracker = title
        performSegue(withIdentifier: "goToProgress", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ProgressViewController
        
//      FIX BELOW SO IT FINDS THE TRACKER METRIC FROM THE TRACKER NAME BUT ONLY IF IT'S THE SAME USER
//        print(usersTrackers[0])
        
        for tracker in usersTrackers {
            if tracker.trackerName == selectedTracker {
                let metric = tracker.trackingMetric
                print(metric)
                destinationVC.trackingMetric = metric
            }
        }
//        if let userEmail = user?.email {
//            let userEmailString = String(userEmail)
//            let docRef = db.collection("trackers")
//            docRef.getDocument { (document, error) in
//                if let document = document, document.exists {
//                    let property = document.get("Tracking Metric") as! String
//                    print(property)
//                    destinationVC.trackingMetric = property
//                } else {
//                    print("Document does not exist")
//                }
//            }
//        }
//
        destinationVC.trackerName = selectedTracker
        
    }
}

//MARK: - CreateTrackerAlert

class CreateTrackerAlert: UIViewController {
    
    let sampleTextField =  UITextField(frame: CGRect(x: 45, y: 100, width: 240, height: 42))
    let items: [UIImage]
    let customSC: UISegmentedControl
    
    init() {
        self.items = [
                UIImage(systemName: "timer")!,
                UIImage(systemName: "number")!,
                UIImage(systemName: "wind")!,
                UIImage(systemName: "snow")!,
                UIImage(named: "crossfit")!
            ]
        self.customSC = UISegmentedControl(items: items)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let db = Firestore.firestore()
    
    struct Constants {
        static let backgroundAlphaTo: CGFloat = 0.6
        static let toggleAlphaTo: CGFloat = 1
    }
    
    private let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0
        return backgroundView
    }()
    
    private let alertView: UIView = {
        let alert = UIView()
        alert.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        alert.layer.masksToBounds = true
        alert.layer.cornerRadius = 12
        return alert
    }()
    
    private var myTargetView: UIView?
    
    func showAlert(with title: String, message: String, on viewController: UIViewController) {

        guard let targetView = viewController.view else {
            return
        }
        
        myTargetView = targetView
        
        backgroundView.frame = targetView.bounds
        targetView.addSubview(backgroundView)
        targetView.addSubview(alertView)
        alertView.frame = CGRect(x: 40, y: -300, width: targetView.frame.size.width-80, height: 350)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: alertView.frame.size.width, height: 80))
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Damascus Bold", size: 16)
        titleLabel.textColor = #colorLiteral(red: 0.1254734099, green: 0.1255019307, blue: 0.1254696548, alpha: 1)
        alertView.addSubview(titleLabel)
        
        let messageLabel = UILabel(frame: CGRect(x: 50, y: 0, width: alertView.frame.size.width, height: 170))
        messageLabel.numberOfLines = 0
        messageLabel.text = message
        messageLabel.font = messageLabel.font.withSize(10)
        messageLabel.textAlignment = .left
        alertView.addSubview(messageLabel)
        
       
            sampleTextField.placeholder = "Name of Tracker"
            sampleTextField.font = UIFont.systemFont(ofSize: 15)
            sampleTextField.borderStyle = UITextField.BorderStyle.roundedRect
            sampleTextField.autocorrectionType = UITextAutocorrectionType.no
            sampleTextField.keyboardType = UIKeyboardType.default
            sampleTextField.returnKeyType = UIReturnKeyType.done
            sampleTextField.clearButtonMode = UITextField.ViewMode.whileEditing
            sampleTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
//            sampleTextField.delegate = self
            alertView.addSubview(sampleTextField)
        
        let recordLabel = UILabel(frame: CGRect(x: 50, y: 100, width: alertView.frame.size.width, height: 170))
        recordLabel.numberOfLines = 0
        recordLabel.text = "What metric works best to track your tracker?"
        recordLabel.font = recordLabel.font.withSize(10)
        recordLabel.textAlignment = .left
        alertView.addSubview(recordLabel)
    
        customSC.selectedSegmentIndex = 0
        customSC.frame = CGRect(x: 45, y: 200,
                                width: 240, height: 42)
        customSC.layer.cornerRadius = 5.0
        customSC.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
        customSC.selectedSegmentTintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        alertView.addSubview(customSC)
        
        let button = UIButton(frame: CGRect(x: 0, y: alertView.frame.height-50, width: alertView.frame.size.width/2, height: 50))
        button.setTitle("Add Tracker", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1), for: .normal)
        button.titleLabel?.font =  UIFont(name: "Arial Bold", size: 14)
        button.backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.4392156863, blue: 0.3607843137, alpha: 1)
        button.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        alertView.addSubview(button)
        
        let cancelButton = UIButton(frame: CGRect(x: alertView.frame.size.width/2, y: alertView.frame.height-50, width: alertView.frame.size.width/2, height: 50))
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(#colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1), for: .normal)
        cancelButton.titleLabel?.font =  UIFont(name: "Arial Bold", size: 14)
        cancelButton.backgroundColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)
        cancelButton.addTarget(self, action: #selector(cancelAlert), for: .touchUpInside)
        alertView.addSubview(cancelButton)
    
        alertView.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundView.alpha = Constants.backgroundAlphaTo
        }, completion: { done in
            if done {
                UIView.animate(withDuration: 0.25, animations: {
                    self.alertView.center = targetView.center
                })
            }
            
        })
        
        
    }
    
    @objc func cancelAlert() {
        guard let targetView = myTargetView else {
            return
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.alertView.frame = CGRect(x: 40, y: targetView.frame.size.height, width: targetView.frame.size.width-80, height: 300)
            
        }, completion: { done in
            if done {
                UIView.animate(withDuration: 0.25, animations: {
                    self.backgroundView.alpha = 0
                    self.sampleTextField.text = ""
                }, completion: { done in
                    if done {
                        self.alertView.removeFromSuperview()
                        self.backgroundView.removeFromSuperview()
                    }
                })
            }
            
        })
        
    }
    
    
    @objc func dismissAlert() {
        if sampleTextField.text! == "" {
            sampleTextField.attributedPlaceholder = NSAttributedString(string: "What would you like to track?",
                                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        } else {
            print(sampleTextField.text!)
            print(customSC.selectedSegmentIndex)
            var selectedTrackingMetric = ""
            
            if customSC.selectedSegmentIndex == 0 {
                selectedTrackingMetric = "time"
            } else if customSC.selectedSegmentIndex == 1 {
                selectedTrackingMetric = "number"
            } else if customSC.selectedSegmentIndex == 2 {
                selectedTrackingMetric = "breathe"
            } else if customSC.selectedSegmentIndex == 3 {
                selectedTrackingMetric = "cold"
            } else if customSC.selectedSegmentIndex == 4 {
                selectedTrackingMetric = "weight"
            }
            
            if let addedGoal = sampleTextField.text, let user = Auth.auth().currentUser?.email {
                self.db.collection("trackers").addDocument(data: [
                        "Name of Tracker" : addedGoal,
                        "user" : user,
                        "Tracking Metric" : selectedTrackingMetric
                ]) { (error) in
                        if let e = error {
                            print("There was an issue saving data to firestore, \(e)")
                        } else {
                            print("Successfully saved data.")
                        }
                    }
                }
        
            guard let targetView = myTargetView else {
                return
            }
            
            UIView.animate(withDuration: 0.25, animations: {
                
                self.alertView.frame = CGRect(x: 40, y: targetView.frame.size.height, width: targetView.frame.size.width-80, height: 300)
                
            }, completion: { done in
                if done {
                    UIView.animate(withDuration: 0.25, animations: {
                        self.backgroundView.alpha = 0
                        self.sampleTextField.text = ""
                    }, completion: { done in
                        if done {
                            self.alertView.removeFromSuperview()
                            self.backgroundView.removeFromSuperview()
                        }
                    })
                }
                
            })
            
        }
        
    }
    
    
}
