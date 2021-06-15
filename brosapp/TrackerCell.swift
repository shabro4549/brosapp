//
//  TrackerCell.swift
//  brosapp
//
//  Created by Shannon Brown on 2021-05-05.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    func didTapButton(with title: String)
}

class TrackerCell: UITableViewCell {
    
    weak var delegate : TrackerCellDelegate?

    @IBOutlet weak var trackerCellButton: UIButton!
    
    static let identifier = "TrackerCell"
    static func nib() -> UINib {
        return UINib(nibName: "TrackerCell", bundle: nil)
    }
    
    private var title: String = ""
    
    @IBAction func didTapButton() {
        delegate?.didTapButton(with: title)
    }
    
    func configure(with title: String) {
        self.title = title
        trackerCellButton.setTitle(title, for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
//        
//    }
}

