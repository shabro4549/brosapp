//
//  BreatheViewController.swift
//  brosapp
//
//  Created by Shannon Brown on 2021-06-01.
//

import UIKit
import Firebase

class BreatheViewController: UIViewController {
    
    var user = Auth.auth().currentUser
    var trackerTitle: String?
    
    let db = Firestore.firestore()

    @IBOutlet weak var breatheView: UIView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var breatheLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var breatheViewHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var breatheViewWidthConstraint : NSLayoutConstraint!
    
    
    var timer = Timer()
    var count = 0
    var timerCounting = false
    var resultString = ""
    var timeInSeconds = ""
    var animationStop = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedbackLabel.alpha = 0
        doneButton.layer.cornerRadius = doneButton.frame.height/2
        doneButton.clipsToBounds = true
        startButton.layer.cornerRadius = startButton.frame.height/2
        startButton.clipsToBounds = true
        resetButton.layer.cornerRadius = resetButton.frame.height/2
        resetButton.clipsToBounds = true

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        breatheLabel.layer.zPosition = 1
        breatheView.layer.zPosition = 0
        print(breatheView.frame)
        breatheView.layer.cornerRadius = breatheView.frame.size.width/2
        breatheView.clipsToBounds = true

        startButton.addTarget(self, action: #selector(animate), for: .touchUpInside)
    }
    
    @objc func animate() {
        self.view.layoutIfNeeded()
        if animationStop == 0 {
            UIView.animate(withDuration: 4) {
                self.breatheLabel.text = "Breathe In"
                self.breatheView.alpha = 1
                self.breatheView.frame = CGRect(x: 115, y: -3, width: 184, height: 184)
                self.breatheView.layer.cornerRadius = self.breatheView.frame.size.width/2
            } completion: { (done) in
                if done {
                    self.shrink()
                }
            }
        } else {
          breatheLabel.text = "Breathe"
            breatheView.frame = CGRect(x: 192, y: 74, width: 30, height: 30)
            breatheView.layer.cornerRadius = breatheView.frame.size.width/2
        }
    }
    
    @objc func shrink() {
        if animationStop == 0 {
            UIView.animate(withDuration: 8) {
                self.breatheLabel.text = "Breathe Out"
                self.breatheView.alpha = 0.25
                self.breatheView.frame = CGRect(x: 192, y: 74, width: 30, height: 30)
                self.breatheView.layer.cornerRadius = self.breatheView.frame.size.width/2
            } completion: { (done) in
                    self.animate()
            }
            
        } else {
            breatheLabel.text = "Breathe"
            breatheView.frame = CGRect(x: 192, y: 74, width: 30, height: 30)
            breatheView.layer.cornerRadius = breatheView.frame.size.width/2
        }
        
    }
    
    @IBAction func startPressed(_ sender: Any) {
        breatheView.frame = CGRect(x: 192, y: 74, width: 30, height: 30)
        breatheView.layer.cornerRadius = breatheView.frame.size.width/2
        breatheView.alpha = 0.25
        
        if(timerCounting) {
            timerCounting = false
            timer.invalidate()
            startButton.setTitle("Start", for: .normal)
            startButton.backgroundColor = #colorLiteral(red: 0.4275401831, green: 0.5684338808, blue: 0.4558522105, alpha: 1)
            animationStop = 1
        } else {
            startButton.setTitle("Stop", for: .normal)
            startButton.backgroundColor = #colorLiteral(red: 0.5019607843, green: 0.2196078431, blue: 0.2235294118, alpha: 1)
            animationStop = 0
            timerCounting = true
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
        timeInSeconds = "\(count)"
    }
    
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int)
    {
        return ((seconds/3600), ((seconds % 3600) / 60), ((seconds % 3600) % 60))
    }
    
    func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String {
        var timeString = ""
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
        animationStop = 1
        breatheView.alpha = 0.25
        breatheView.frame = CGRect(x: 192, y: 74, width: 30, height: 30)
        breatheView.layer.cornerRadius = breatheView.frame.size.width/2
    
        count = 0
        timer.invalidate()
        timerLabel.text = makeTimeString(hours: 0, minutes: 0, seconds: 0)
        startButton.setTitle("Start", for: .normal)
        startButton.backgroundColor = #colorLiteral(red: 0.4275401831, green: 0.5684338808, blue: 0.4558522105, alpha: 1)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        if timerLabel.text == "0 0 : 0 0" {
            feedbackLabel.alpha = 1
            feedbackLabel.text = "No session has been timed"
            feedbackLabel.textColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
        } else {
        let date = Date()
        let sortingDate = date.timeIntervalSince1970
        
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "MMM d, yy"
        let currentDate = formatter.string(from: date)
                
        self.db.collection("progress").addDocument(data: [
                "LengthInSeconds" : timeInSeconds,
                "UserEmail" : user?.email!,
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
        
        navigationController?.popViewController(animated: true)
        }
    }

}
