//
//  WeightViewController.swift
//  brosapp
//
//  Created by Shannon Brown on 2021-05-21.
//

import UIKit
import Firebase

class WeightViewController: UIViewController, UITextFieldDelegate {
    
    var user = Auth.auth().currentUser
    var trackerTitle: String?
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var setsTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weightTextField.delegate = self
        weightTextField.tag = 1
        repsTextField.delegate = self
        repsTextField.tag = 2
        setsTextField.delegate = self
        setsTextField.tag = 3
        doneButton.layer.cornerRadius = doneButton.frame.height/2
        doneButton.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func donePressed(_ sender: Any) {
        if weightTextField.text == "" {
            weightTextField.placeholder = "Enter a weight"
        } else if repsTextField.text == "" {
            repsTextField.placeholder = "Enter reps"
        } else if setsTextField.text == "" {
            setsTextField.placeholder = "Enter sets"
        } else {
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
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1
        {
            weightTextField.endEditing(true)
            return true
        } else if textField.tag == 2
        {
            repsTextField.endEditing(true)
            return true
        } else {
            setsTextField.endEditing(true)
            return true
        }
    }
    

}
