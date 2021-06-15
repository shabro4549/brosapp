//
//  ResultsCell.swift
//  brosapp
//
//  Created by Shannon Brown on 2021-06-10.
//

import UIKit

class ResultsCell: UITableViewCell {
    
    static let identifier = "TrackerCell"
    static func nib() -> UINib {
        return UINib(nibName: "TrackerCell", bundle: nil)
    }
    @IBOutlet weak var nameLabel: UILabel!
    
    func configure(with trackerName: String) {
        nameLabel.text = trackerName
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
