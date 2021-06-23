//
//  GraphCell.swift
//  brosapp
//
//  Created by Shannon Brown on 2021-06-23.
//

import UIKit
import Charts
import TinyConstraints

class GraphCell: UITableViewCell, ChartViewDelegate {

    @IBOutlet weak var trackerLabel: UILabel!
    
    static let identifier = "GraphCell"
    static func nib() -> UINib {
        return UINib(nibName: "GraphCell", bundle: nil)
    }
    
    private var title: String = ""
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.rightAxis.enabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.backgroundColor = .systemGray
        return chartView
    }()
    let yValues: [ChartDataEntry] = [
        ChartDataEntry(x: 1, y: 1)
    ]
    
    func configure(with title: String) {
        self.title = title
        trackerLabel.text = title
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func setData() {
        let set1 = LineChartDataSet(entries: yValues, label: "Data")
        let data = LineChartData(dataSet: set1)
        lineChartView.data = data
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
        contentView.addSubview(lineChartView)
        lineChartView.centerInSuperview()
        lineChartView.width(275)
        lineChartView.height(150)
        
        setData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
