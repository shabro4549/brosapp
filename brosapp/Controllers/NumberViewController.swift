//
//  NumberViewController.swift
//  brosapp
//
//  Created by Shannon Brown on 2021-06-01.
//

import UIKit
import Firebase

class NumberViewController: UIViewController {
    
    var user = Auth.auth().currentUser
    var trackerTitle: String?
    
    let db = Firestore.firestore()

    @IBOutlet weak var numberLabel: UITextField!
    @IBOutlet weak var stepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        numberLabel.delegate = self
        numberLabel.text = "0"
        numberLabel.keyboardType = .numberPad
        // Do any additional setup after loading the view.
    }
    
    @IBAction func stepperPressed(_ sender: UIStepper) {
        numberLabel.text = String(Int(sender.value))
    }
    
    
    @IBAction func donePressed(_ sender: Any) {
        let date = Date()
        let sortingDate = date.timeIntervalSince1970
        
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "MMM d, yy"
        let currentDate = formatter.string(from: date)
        
        let number = numberLabel.text!
    
        self.db.collection("progress").addDocument(data: [
            "UserEmail" : user?.email!,
            "Tracker" : trackerTitle!,
            "Date" : currentDate,
            "TimeCreated" : sortingDate,
            "Number" : number,

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


//extension NumberViewController : UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        print(numberLabel.text!)
//        return true
//    }
//}
