//
//  ViewController.swift
//  ecgapp
//
//  Created by Omar Habra on 4/30/20.
//  Copyright © 2020 Omar Habra. All rights reserved.
//

import UIKit
import Charts
class ViewController: UIViewController {
    
    
    let EcgChart = LineChartView()
    
    var dataEntries = [ChartDataEntry]()
    
    var xValue: Double = 8

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupInitialDataEntries()
        setupChartData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(didUpdatedChartView), userInfo: nil, repeats: true)
    }
    
    @objc func didUpdatedChartView() {
        let newDataEntry = ChartDataEntry(x: xValue,
                                          y: Double.random(in: 0...50))
        updateChartView(with: newDataEntry, dataEntries: &dataEntries)
        xValue += 1
    }
    
    func setupViews() {
        view.addSubview(EcgChart)
        EcgChart.translatesAutoresizingMaskIntoConstraints = false
        EcgChart.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        EcgChart.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        EcgChart.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        EcgChart.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    func setupInitialDataEntries() {
        (0..<Int(xValue)).forEach {
            let dataEntry = ChartDataEntry(x: Double($0), y: 0)
            dataEntries.append(dataEntry)
        }
    }
    
    func setupChartData() {
        // 1
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "set1")
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.setColor(NSUIColor.red)
        chartDataSet.mode = .linear
        
        // 2
        let chartData = LineChartData(dataSet: chartDataSet)
        EcgChart.data = chartData
        EcgChart.xAxis.labelPosition = .bottom
    }
    
    func updateChartView(with newDataEntry: ChartDataEntry, dataEntries: inout [ChartDataEntry]) {
        if let oldEntry = dataEntries.first {
            dataEntries.removeFirst()
            EcgChart.data?.removeEntry(oldEntry, dataSetIndex: 0)
        }
        
        dataEntries.append(newDataEntry)
        EcgChart.data?.addEntry(newDataEntry, dataSetIndex: 0)
        
        EcgChart.notifyDataSetChanged()
        EcgChart.moveViewToX(newDataEntry.x)
    }
    }


