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
    
//    let date = Date()
    
    func configure(with length: String) {
        print("length in cell: \(length)")
        progressLabel.text = length

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}






