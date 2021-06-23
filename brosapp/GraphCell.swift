//
//  GraphCell.swift
//  brosapp
//
//  Created by Shannon Brown on 2021-06-23.
//

import UIKit

class GraphCell: UITableViewCell {

    @IBOutlet weak var trackerLabel: UILabel!
    
    static let identifier = "GraphCell"
    static func nib() -> UINib {
        return UINib(nibName: "GraphCell", bundle: nil)
    }
    
    private var title: String = ""
    
    func configure(with title: String) {
        self.title = title
        trackerLabel.text = title
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
