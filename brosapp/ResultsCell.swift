//
//  ResultsCell.swift
//  brosapp
//
//  Created by Shannon Brown on 2021-06-10.
//

import UIKit
//import Firebase

class ResultsCell: UITableViewCell {
    
    static let identifier = "ResultsCell"
    static func nib() -> UINib {
        return UINib(nibName: "ResultsCell", bundle: nil)
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var resultsView: UIView!
//    let db = Firestore.firestore()
    @IBOutlet weak var longestLabel: UILabel!
    @IBOutlet weak var shortestLabel: UILabel!
    @IBOutlet weak var avgLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var shortTitle: UILabel!
    @IBOutlet weak var longTitle: UILabel!
    @IBOutlet weak var sessionNumberLabel: UILabel!
    
    func configure(with trackerName: String, with highestValue: Float, with lowestValue: Float, with avgValue: Float, with isWeight: Bool, with sessions: Int) {
        nameLabel.text = trackerName
        longestLabel.text = String(highestValue)
        shortestLabel.text = String(lowestValue)
        avgLabel.text = String(round(100*avgValue)/100)
        sessionNumberLabel.text = String(sessions)
        if isWeight == true {
            weightLabel.isHidden = false
        } else {
            weightLabel.isHidden = true
        }
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        let background = CAGradientLayer().backgroundGradientColor()
        background.frame = self.resultsView.bounds
        self.resultsView.layer.insertSublayer(background, at: 0)
        resultsView.layer.cornerRadius = (resultsView.frame.height)/2
        resultsView.clipsToBounds = true
        longTitle.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        shortTitle.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension CAGradientLayer {

    func backgroundGradientColor() -> CAGradientLayer {
//        let topColor = UIColor(red: 173, green: 173, blue: 173, alpha: 1)
//        let bottomColor = UIColor(red: 51, green: 51, blue: 51, alpha: 1)

        let topColor = UIColor(red: (173/255.0), green: (173/255.0), blue:(173/255.0), alpha: 1)
        let bottomColor = UIColor(red: (51/255.0), green: (51/255.0), blue:(51/255.0), alpha: 1)

        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
//        let gradientLocations: [NSNumber] = [0.0, 1.0]

        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
//        gradientLayer.locations = gradientLocations
        return gradientLayer

    }
}
