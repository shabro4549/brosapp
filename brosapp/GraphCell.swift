//
//  GraphCell.swift
//  brosapp
//
//  Created by Shannon Brown on 2021-06-23.
//

import UIKit
import Charts
import TinyConstraints
import Firebase

class GraphCell: UITableViewCell, ChartViewDelegate {

    @IBOutlet weak var trackerLabel: UILabel!
    
    let db = Firestore.firestore()
    var user = Auth.auth().currentUser
    var progressCells: [Progress] = []
    static let identifier = "GraphCell"
    static func nib() -> UINib {
        return UINib(nibName: "GraphCell", bundle: nil)
    }
    var usersTrackers: [Tracker] = []
    
    private var title: String = ""
    private var metric: String = ""
//    var yValues: [ChartDataEntry] = [
//        ChartDataEntry(x: 1623365569.3165, y: 1),
//        ChartDataEntry(x: 1633365569.3165, y: 2)
//    ]
    
    func configure(with title: String, with metric: String, with trackers: [Tracker]) {
        self.title = title
        self.metric = metric
        trackerLabel.text = title
        usersTrackers = trackers

        if metric == "weight" {
            let lineChartView: LineChartView = {
                let chartView = LineChartView()
                chartView.rightAxis.enabled = false
                chartView.xAxis.labelPosition = .bottom
                chartView.xAxis.drawGridLinesEnabled = false
                chartView.backgroundColor = .systemGray
    
                let xAxis=XAxis()
                let xAxisFormatter = MyXAxisValueFormatter()
                xAxis.valueFormatter=xAxisFormatter
                chartView.xAxis.valueFormatter=xAxis.valueFormatter
//                chartView.drawGridBackgroundEnabled = false
                return chartView
            }()
            var yValues: [ChartDataEntry] = []
            db.collection("weightProgress").whereField("Tracker", isEqualTo: title).getDocuments { [self] (querySnapshot, error) in
                yValues = []
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        if let xValue = (data["TimeCreated"] as? NSNumber), let yValue = data["Weight"] as? String {
                            let xValueToDouble = Double(xValue.stringValue)!
                            let yValueToDouble = Double(yValue)!
                            yValues.append(ChartDataEntry(x: xValueToDouble, y: yValueToDouble))
                        }
                    }
                    let set1 = LineChartDataSet(entries: yValues, label: "Data")
                    set1.setColor(#colorLiteral(red: 0.1725490196, green: 0.4392156863, blue: 0.3607843137, alpha: 1))
//                    set1.highlightColor = UIColor.systemBlue
//                    #44705B
                    set1.circleColors = [#colorLiteral(red: 0.1725490196, green: 0.4392156863, blue: 0.3607843137, alpha: 1)]
                    set1.valueFont = UIFont.boldSystemFont(ofSize: 12)
                    let data = LineChartData(dataSet: set1)
                    lineChartView.data = data
                    contentView.addSubview(lineChartView)
                    lineChartView.centerInSuperview()
                    lineChartView.width(320)
                    lineChartView.height(230)
                    lineChartView.layer.cornerRadius = 10
                    lineChartView.clipsToBounds = true
//                    lineChartView.drawGridBackgroundEnabled = false
                }
            }
        } else {
            let lineChartView: LineChartView = {
                let chartView = LineChartView()
                chartView.rightAxis.enabled = false
                chartView.xAxis.labelPosition = .bottom
                chartView.backgroundColor = .systemGray
//                chartView.drawGridBackgroundEnabled = false
                chartView.xAxis.drawGridLinesEnabled = false
                let xAxis=XAxis()
                let xAxisFormatter = MyXAxisValueFormatter()
                xAxis.valueFormatter=xAxisFormatter
                chartView.xAxis.valueFormatter=xAxis.valueFormatter
                return chartView
            }()
            var yValues: [ChartDataEntry] = []
            db.collection("progress").whereField("Tracker", isEqualTo: title).order(by: "TimeCreated", descending: false).getDocuments { [self] (querySnapshot, error) in
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        if metric == "number" {
                            if let xValue = (data["TimeCreated"] as? NSNumber), let yValue = data["Number"] as? String {
                                let xValueToDouble = Double(xValue.stringValue)!
                                let yValueToDouble = Double(yValue)!
                                print("x: \(xValueToDouble), y: \(yValueToDouble)")
                                yValues.append(ChartDataEntry(x: xValueToDouble, y: yValueToDouble))
                            }
                        } else {
                            if let xValue = (data["TimeCreated"] as? NSNumber), let yValue = data["LengthInSeconds"] as? String {
                                let xValueToDouble = Double(xValue.stringValue)!
                                let yValueToDouble = Double(yValue)!
                                print("x: \(xValueToDouble), y: \(yValueToDouble)")
                                yValues.append(ChartDataEntry(x: xValueToDouble, y: yValueToDouble))
                            }
                        }
                    }

                    print(yValues)
                    let set1 = LineChartDataSet(entries: yValues, label: "Data")
                    set1.setColor(#colorLiteral(red: 0.1725490196, green: 0.4392156863, blue: 0.3607843137, alpha: 1))
//                    set1.highlightColor = UIColor.systemBlue
//                    #44705B
                    set1.circleColors = [#colorLiteral(red: 0.1725490196, green: 0.4392156863, blue: 0.3607843137, alpha: 1)]
                    set1.valueFont = UIFont.boldSystemFont(ofSize: 12)
                    let data = LineChartData(dataSet: set1)
                    lineChartView.data = data
                    contentView.addSubview(lineChartView)
                    lineChartView.centerInSuperview()
                    lineChartView.width(320)
                    lineChartView.height(230)
                    lineChartView.layer.cornerRadius = 10
                    lineChartView.clipsToBounds = true
//                    lineChartView.drawGridBackgroundEnabled = false
                }
            }
        }
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
//        contentView.addSubview(lineChartView)
//        lineChartView.centerInSuperview()
//        lineChartView.width(300)
//        lineChartView.height(160)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
