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
    @IBOutlet weak var checkedIndicator: UIImageView!
    

//    override var isSelected: Bool {
//        didSet {
//            if checkedIndicator.isHidden == true {
//                checkedIndicator.isHidden = false
//            } else {
//                checkedIndicator.isHidden = true
//            }
//        }
//    }
    
    func configure(with weight: String, with reps: String, with sets: String, with date: String, with created: String, with selected: Bool) {
        repsLabel.text = "\(reps) Reps"
        setsLabel.text = "\(sets) Sets"
        progressLabel.text = "\(weight) lbs"
        dateLabel.text = date
        
        if selected == false {
            checkedIndicator.isHidden = true
        } else {
            checkedIndicator.isHidden = false
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        checkedIndicator.isHidden = true

    }

}






