//
//  ProgressCollectionCell.swift
//  brosapp
//
//  Created by Shannon Brown on 2021-05-26.
//

import UIKit

class ProgressCollectionCell: UICollectionViewCell {

    @IBOutlet weak var progressLabel: UILabel!
    static let identifier = "ProgressCollectionCell"
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    

    
    func configure(with length: String, with reps: String, with sets: String, with date: String, with tracker: String) {
        print("the tracker in the cell is: \(tracker)")
        if tracker == "Cold Shower" {
            repsLabel.alpha = 0
            setsLabel.alpha = 0
            if let lengthToDouble = Double(length) {
                if lengthToDouble <= 59 {
                    progressLabel.text = "\(length)s"
                } else if lengthToDouble == 60 {
                    progressLabel.text = "1m"
                } else {
                    let minutes = floor(lengthToDouble/60)
                    let remainingSeconds = lengthToDouble - (minutes * 60)
                    progressLabel.text = "\(Int(minutes))m \(Int(remainingSeconds))s"
                }
            }
        } else {
            repsLabel.alpha = 1.0
            setsLabel.alpha = 1.0
            repsLabel.text = "\(reps) Reps"
            setsLabel.text = "\(sets) Sets"
            print("In progress cell weight is \(length)")
            progressLabel.text = "\(length) lbs"
        }
        
        dateLabel.text = date
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

}






