//
//  ViewController.swift
//  NetworkingAss1
//
//  Created by Nguyễn Ngọc Thành on 2/14/19.
//  Copyright © 2019 Nguyễn Ngọc Thành. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {

    //MARK: - Declare Initial variable
    @IBOutlet weak var btnSetThreshold: UIButton!
    @IBOutlet weak var btnDraw: UIButton!
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var thresholdLabel: UILabel!
    weak var axisFormatDelegate: IAxisValueFormatter?
    var limitLine = ChartLimitLine()
    var thresholdValue: Double = 0
    var dataOnChart = LineChartData()
    var lineChartEntry  = [ChartDataEntry]()
    var arrayData = [DataChart]()
    var line = LineChartDataSet()
    
    //MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        btnDraw.layer.cornerRadius = 4
        btnSetThreshold.layer.cornerRadius = 4
        axisFormatDelegate = self
        draw()
    }
    
    //MARK: - Button Set Threshold Function

    @IBAction func btnSetThresholdPress(_ sender: Any) {
        
        self.lineChart.leftAxis.removeAllLimitLines()
        var myTextField = UITextField()
        let alert = UIAlertController(title: "Enter Threshold Value", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            
            self.thresholdValue = Double(myTextField.text!)!
            self.limitLine = ChartLimitLine(limit: self.thresholdValue)
            self.lineChart.leftAxis.addLimitLine(self.limitLine)
            self.lineChart.animate(yAxisDuration: 0.00001)
            self.thresholdLabel.text = "THRESHOLD : \(self.thresholdValue)"
            
            }
        alert.addTextField { (textField) in
            
            myTextField  = textField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        //lineChart.reloadInputViews()
        
    }
    
    //MARK: - Button Draw Function
    @IBAction func btnDrawPress(_ sender: Any) {
        draw()
    }
    
    func draw() {
        let date = Date()
        var tmpTime =  Double(Calendar.current.component(.second, from: date))
        arrayData.removeAll()
        for _ in 0 ..< 50 {
            
            let data = DataChart()
            data.value = Double(Int.random(in: 100 ... 1000))
            data.time = tmpTime
            arrayData.append(data)
            tmpTime += 5
            print("---- \(data.value) -- \(data.time)")
        }
        
        lineChartEntry.removeAll()
        for i in 0 ..< arrayData.count {
            let value = ChartDataEntry(x: arrayData[i].time, y: arrayData[i].value)
           
            lineChartEntry.append(value)
        }
        
        dataOnChart.removeDataSet(line)
        line = LineChartDataSet(values: lineChartEntry, label: "Value")
        line.colors = [UIColor .blue]
        line.circleColors = [UIColor .red]
        line.circleRadius = 2
        line.valueColors = [UIColor .red]
        line.lineWidth = 2
        dataOnChart.addDataSet(line)
        lineChart.data = dataOnChart
//        lineChart.xAxis.valueFormatter = axisFormatDelegate
        updateUI()
        lineChart.notifyDataSetChanged()
        dataOnChart.notifyDataChanged()
    }
    
    //MARK: - Update UI
    func updateUI() {
//        lineChart.xAxis.valueFormatter = axisFormatDelegate
        lineChart.xAxis.enabled = false
        lineChart.borderLineWidth = 0
        lineChart.animate(xAxisDuration: 3, yAxisDuration: 3)
        lineChart.rightAxis.enabled = false
        lineChart.doubleTapToZoomEnabled = false
        lineChart.pinchZoomEnabled = false
    }
}

// MARK: - extension Date Format for xAxis
extension ViewController: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ss"
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}



