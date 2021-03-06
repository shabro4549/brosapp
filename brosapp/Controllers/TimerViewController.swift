//
//  TimerViewController.swift
//  brosapp
//
//  Created by Shannon Brown on 2021-06-01.
//

import UIKit
import Firebase

class TimerViewController: UIViewController {
    
    var user = Auth.auth().currentUser
    var trackerTitle: String?
    
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    let db = Firestore.firestore()
    
    var timer = Timer()
    var count = 0
    var timerCounting = false
    var resultString = ""
    var timeInSeconds = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "\(trackerTitle!)"
        doneButton.layer.cornerRadius = doneButton.frame.height/2
        doneButton.clipsToBounds = true
        startStopButton.layer.cornerRadius = startStopButton.frame.height/2
        startStopButton.clipsToBounds = true
        resetButton.layer.cornerRadius = resetButton.frame.height/2
        resetButton.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startStopPressed(_ sender: Any) {
        
        if(timerCounting) {
            timerCounting = false
            timer.invalidate()
            startStopButton.setTitle("Start", for: .normal)
            startStopButton.backgroundColor = #colorLiteral(red: 0.4275401831, green: 0.5684338808, blue: 0.4558522105, alpha: 1)
        } else {
            timerCounting = true
            startStopButton.setTitle("Stop", for: .normal)
            startStopButton.backgroundColor = #colorLiteral(red: 0.5019607843, green: 0.2196078431, blue: 0.2235294118, alpha: 1)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        }
    }
    
    @objc func timerCounter() -> Void
    {
        count = count + 1
        let time = secondsToHoursMinutesSeconds(seconds: count)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        timerLabel.text = timeString
        resultString = timeString
//        print(count)
        timeInSeconds = "\(count)"
    }
    
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int)
    {
        return ((seconds/3600), ((seconds % 3600) / 60), ((seconds % 3600) % 60))
    }
    
    func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String {
        var timeString = ""
//        if hours <= 9 {
//            timeString += String(format: "0%2d", hours)
//        } else {
//            timeString += String(format: "%2d", hours)
//        }
//        timeString += " : "
        if minutes <= 9 {
            timeString += String(format: "0%2d", minutes)
        } else {
            timeString += String(format: "%2d", minutes)
        }
        timeString += " : "
        if seconds <= 9 {
            timeString += String(format: "0%2d", seconds)
        } else {
            timeString += String(format: "%2d", seconds)
        }
        return timeString
    }
    
    @IBAction func resetPressed(_ sender: Any) {
        count = 0
        timer.invalidate()
        timerLabel.text = makeTimeString(hours: 0, minutes: 0, seconds: 0)
        startStopButton.setTitle("Start", for: .normal)
//        introLabel.text = "Are you ready?"
        startStopButton.setTitleColor(UIColor.green, for: .normal)
        
    }
    
    @IBAction func donePressed(_ sender: Any) {
        if timerLabel.text == "0 0 : 0 0" {
            titleLabel.text = "No session has been timed"
            titleLabel.textColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
        } else {
            let date = Date()
            let sortingDate = date.timeIntervalSince1970
            
            let formatter = DateFormatter()
            formatter.timeZone = .current
            formatter.locale = .current
            formatter.dateFormat = "MMM d, yy"
            let currentDate = formatter.string(from: date)
    //        print(currentDate)
            
            if let userEmail = user?.email {
                self.db.collection("progress").addDocument(data: [
                        "LengthInSeconds" : timeInSeconds,
                        "UserEmail" : userEmail,
                        "Tracker" : trackerTitle!,
                        "Date" : currentDate,
                        "TimeCreated" : sortingDate
                ]) { (error) in
                        if let e = error {
                            print("There was an issue saving data to firestore, \(e)")
                        } else {
                            print("Successfully saved data.")
                        }
                    }
            } else {
                print("Error unwrapping email in TimerViewController")
            }
            
            
            navigationController?.popViewController(animated: true)
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
