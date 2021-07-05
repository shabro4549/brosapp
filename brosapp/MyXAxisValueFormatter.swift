//
//  GraphFormatter.swift
//  brosapp
//
//  Created by Shannon Brown on 2021-06-23.
//

import Foundation
import Charts
import TinyConstraints

public class MyXAxisValueFormatter: IAxisValueFormatter {
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "MMM d"
        let currentDate = formatter.string(from: NSDate(timeIntervalSince1970: value) as Date)
        return currentDate
    }
}
