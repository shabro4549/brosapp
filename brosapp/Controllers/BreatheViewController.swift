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
    
    var timer = Timer()
    var count = 0
    var timerCounting = false
    var resultString = ""
    var timeInSeconds = ""
    var animationStop = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            
        breatheView.layer.cornerRadius = breatheView.frame.size.width/2
        breatheView.clipsToBounds = true
        
        startButton.addTarget(self, action: #selector(animate), for: .touchUpInside)
    }
    
    @objc func animate() {
        if animationStop == 0 {
            UIView.animate(withDuration: 4) {
                    self.breatheLabel.text = "Breathe in"
                    self.breatheView.frame = CGRect(x: 108, y: 348, width: 200, height: 200)
                    self.breatheView.layer.cornerRadius = self.breatheView.frame.size.width/2
                    self.breatheView.alpha = 1
            } completion: { (done) in
                if done {
//                    if self.animationStop == 0 {
                        self.shrink()
//                    } else {
//                        self.breatheLabel.text = "Breathe"
//                        self.breatheView.frame = CGRect(x: 192, y: 433, width: 30, height: 30)
//                        self.breatheView.layer.cornerRadius = self.breatheView.frame.size.width/2
//                        self.breatheView.alpha = 0.25
//                    }
                }
            }
        } else {
          breatheLabel.text = "Breathe"
          breatheView.frame = CGRect(x: 192, y: 433, width: 30, height: 30)
          breatheView.layer.cornerRadius = self.breatheView.frame.size.width/2
          breatheView.alpha = 0.25
        }
    }
    
    @objc func shrink() {
        
        if animationStop == 0 {
            UIView.animate(withDuration: 8) {
//                if self.animationStop == 0 {
                    self.breatheView.frame = CGRect(x: 192, y: 433, width: 30, height: 30)
                    self.breatheView.layer.cornerRadius = self.breatheView.frame.size.width/2
                    self.breatheLabel.text = "Breathe Out"
                    self.breatheView.alpha = 0.25
//                } else {
//                    self.breatheLabel.text = "Breathe"
//                    self.breatheView.frame = CGRect(x: 192, y: 433, width: 30, height: 30)
//                    self.breatheView.layer.cornerRadius = self.breatheView.frame.size.width/2
//                    self.breatheView.alpha = 0.25
//                }
                
            } completion: { (done) in
//                if self.animationStop == 0 {
                    self.animate()
//                } else {
//                    self.breatheLabel.text = "Breathe"
//                    self.breatheView.frame = CGRect(x: 192, y: 433, width: 30, height: 30)
//                    self.breatheView.layer.cornerRadius = self.breatheView.frame.size.width/2
//                    self.breatheView.alpha = 0.25
//                }
            }
            
        } else {
            breatheLabel.text = "Breathe"
            breatheView.frame = CGRect(x: 192, y: 433, width: 30, height: 30)
            breatheView.layer.cornerRadius = self.breatheView.frame.size.width/2
            breatheView.alpha = 0.25
        }
        
    }
    
    @IBAction func startPressed(_ sender: Any) {
//        breatheView.alpha = 0.25
//        breatheView.frame = CGRect(x: 192, y: 433, width: 30, height: 30)
//        breatheView.layer.cornerRadius = breatheView.frame.size.width/2
        breatheView.alpha = 0.25
        breatheView.frame = CGRect(x: 192, y: 433, width: 30, height: 30)
        breatheView.layer.cornerRadius = breatheView.frame.size.width/2
        
        if(timerCounting) {
//            self.breatheView.frame = CGRect(x: 108, y: 348, width: 200, height: 200)
//            self.breatheView.layer.cornerRadius = self.breatheView.frame.size.width/2
//            self.breatheView.alpha = 1
            timerCounting = false
            timer.invalidate()
            startButton.setTitle("Start", for: .normal)
            startButton.setTitleColor(UIColor.green, for: .normal)
            animationStop = 1
            
        } else {
//            breatheView.alpha = 0.25
//            breatheView.frame = CGRect(x: 192, y: 433, width: 30, height: 30)
//            breatheView.layer.cornerRadius = breatheView.frame.size.width/2
            animationStop = 0
            timerCounting = true
            startButton.setTitle("Stop", for: .normal)
            startButton.setTitleColor(UIColor.red, for: .normal)
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
//        var layer = breatheView.layer.presentation()! as CALayer
//        var frame = layer.frame
//        breatheView.layer.removeAllAnimations()
//        breatheView.frame = frame
        
//        print(UIView.areAnimationsEnabled)
//        UIView.AnimationOptions.remove()
        animationStop = 1
        breatheView.alpha = 0.25
        breatheView.frame = CGRect(x: 192, y: 433, width: 30, height: 30)
        breatheView.layer.cornerRadius = breatheView.frame.size.width/2
        
//        UIView.setAnimationsEnabled(false)
//        startButton.removeTarget(<#T##target: Any?##Any?#>, action: <#T##Selector?#>, for: <#T##UIControl.Event#>)
//        self.view.subviews.forEach({$0.layer.removeAllAnimations()})
//            self.view.layer.removeAllAnimations()
//            self.view.layoutIfNeeded()
    
        count = 0
        timer.invalidate()
        timerLabel.text = makeTimeString(hours: 0, minutes: 0, seconds: 0)
        startButton.setTitle("Start", for: .normal)
        startButton.setTitleColor(UIColor.green, for: .normal)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        let date = Date()
        let sortingDate = date.timeIntervalSince1970
        
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "MMM d, yy"
        let currentDate = formatter.string(from: date)
//        print(currentDate)
        
//        timeInSeconds = timerLabel.text!
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
