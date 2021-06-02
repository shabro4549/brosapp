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
    

    
    func configure(with weight: String, with reps: String, with sets: String, with date: String, with tracker: String) {
        repsLabel.text = "\(reps) Reps"
        setsLabel.text = "\(sets) Sets"
        progressLabel.text = "\(weight) lbs"
        dateLabel.text = date
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        // Initialization code

    }

}






