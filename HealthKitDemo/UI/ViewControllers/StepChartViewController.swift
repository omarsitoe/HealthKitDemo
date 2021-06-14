//
//  StepChartViewController.swift
//  HealthKitDemo
//
//  Created by Omar Trejo on 6/6/21.
//

import UIKit
import HealthKit
import CareKit

//MARK: - Step Chart Graph Controller
class StepChartViewController: OCKCartesianChartViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !HKHealthStore.isHealthDataAvailable() {
            fatalError("Health Store not available on platform")
        }
        HealthData.InfoAuthorization()
        
        chartView.graphView.dataSeries = HealthData.graphValues
    }
    
}

//MARK: - Chart Synchronizer
class StepChartViewSynchronizer: OCKCartesianChartViewSynchronizer {

    // Customize the initial state of the view
    override func makeView() -> OCKCartesianChartView {
        let chartView = super.makeView()
        HealthData.calculateDailySteps(date: selectedDate)
        return chartView
    }
}
