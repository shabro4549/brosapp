//
//  TimeNumberCollectionCell.swift
//  brosapp
//
//  Created by Shannon Brown on 2021-06-03.
//

import UIKit

class TimeNumberCollectionCell: UICollectionViewCell {
    
    static let identifier = "TimeNumberCollectionCell"
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configure(with length: String, with date: String, with tracker: String, with metric: String) {
        if metric == "number" {
            progressLabel.text = length
        } else {
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
        }
        
        
        dateLabel.text = date
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
