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
        progressLabel.text = length
        dateLabel.text = date
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}






