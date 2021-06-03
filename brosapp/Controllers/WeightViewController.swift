//
//  WeightViewController.swift
//  brosapp
//
//  Created by Shannon Brown on 2021-05-21.
//

import UIKit
import Firebase

class WeightViewController: UIViewController {
    
    var user = Auth.auth().currentUser
    var trackerTitle: String?
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var setsTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func donePressed(_ sender: Any) {
        

            let date = Date()
            let sortingDate = date.timeIntervalSince1970
            
            let formatter = DateFormatter()
            formatter.timeZone = .current
            formatter.locale = .current
            formatter.dateFormat = "MMM d, yy"
            let currentDate = formatter.string(from: date)
            
            let weight = weightTextField.text!
            let reps = repsTextField.text!
            let sets = setsTextField.text!
            
            
            self.db.collection("weightProgress").addDocument(data: [
                "UserEmail" : user?.email!,
                "Tracker" : trackerTitle!,
                "Date" : currentDate,
                "TimeCreated" : sortingDate,
                "Weight" : weight,
                "Reps" : reps,
                "Sets" : sets
            ])
            
            navigationController?.popViewController(animated: true)
        
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
