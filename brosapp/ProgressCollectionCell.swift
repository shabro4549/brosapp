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
    

    
    func configure(with length: String, with date: String) {
        if let lengthToDouble = Double(length) {
            if lengthToDouble <= 59 {
                progressLabel.text = "\(length)s"
            } else if lengthToDouble == 60 {
                progressLabel.text = "1m"
            } else {
                let minutes = floor(lengthToDouble/60)
                print(minutes)
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






