//
//  ColdCollectionCell.swift
//  brosapp
//
//  Created by Shannon Brown on 2021-05-31.
//

import UIKit

class ColdCollectionCell: UICollectionViewCell {
    
    static let identifier = "ColdCollectionCell"
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    
    func configure(with length: String, with date: String, with tracker: String) {
        print("the tracker in the cell is: \(tracker)")
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
        
        
        dateLabel.text = date
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
