//
//  HealthData.swift
//  HealthKitDemo
//
//  Created by Omar Trejo on 6/5/21.
//

import Foundation
import HealthKit
import UIKit
import CareKit

class HealthData {
    
    static var healthStore: HKHealthStore = HKHealthStore()
    static var graphValues: [OCKDataSeries] = {
        return []
    }()
    static var currentWeek: Date?
    static var controller: StepChartViewController?
    
    //MARK: - HKHealthStore Setup
    class func InfoAuthorization() {
        let reqTypes = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!,
                            HKObjectType.quantityType(forIdentifier: .stepCount)!])
        
        healthStore.requestAuthorization(toShare: reqTypes, read: reqTypes) { (success, error) in
            if !success {
                // Try again if failed
                //NOTE: failure does NOT mean user denied permission
                print("Something went wrong. Trying again...")
                self.InfoAuthorization()
            }
        }
    }
    
    //MARK: - Run Query on Data
    class func calculateDailySteps(date: Date) {
        // Run statistic query
        //Declare types to query (for now just do step count)
        // i.e. Step Count
        //      Heart Rate
        //      Sleep Hours (maybe)
        guard let stepType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else {
            // This should never fail when using a defined constant.
            fatalError("*** Unable to get the step count type ***")
        }

        // Set anchor date (arbritarily Monday at 3am) and time interval
        let calendar = Calendar.current
        let interval = DateComponents(day: 1)
        let components = DateComponents(calendar: calendar,
                                        timeZone: calendar.timeZone,
                                        hour: 0,
                                        minute: 0,
                                        second: 0,
                                        weekday: 2)
        
        guard let anchorDate = calendar.nextDate(after: date,
                                                 matching: components,
                                                 matchingPolicy: .nextTime,
                                                 repeatedTimePolicy: .first,
                                                 direction: .backward) else {
            fatalError("*** unable to find the previous Monday. ***")
        }
        
        let currentWeekday = calendar.component(.weekday, from: date)
        let firstWeekday = calendar.firstWeekday
        var offset = (currentWeekday - 1) - (firstWeekday - 1)
        if offset < 0 {
            offset += 7
        }
        offset *= -1
        
        guard let beginningOfWeek = calendar.date(byAdding: DateComponents(day: offset), to: date),
              let endOfWeek = calendar.date(byAdding: DateComponents(day: 6), to: beginningOfWeek) else {
            fatalError("*** Could not access specified date range ***")
        }
        
        print("Start: \(beginningOfWeek)")
        print("End:   \(endOfWeek)\n")
        
        if beginningOfWeek == currentWeek {
            //print("no new query needed!")
            return
        }
        currentWeek = beginningOfWeek
        
        let weekAgo = HKQuery.predicateForSamples(withStart: beginningOfWeek, end: endOfWeek, options: .strictStartDate)
        let query = HKStatisticsCollectionQuery(quantityType: stepType,
                                                quantitySamplePredicate: weekAgo,
                                                options: .cumulativeSum,
                                                anchorDate: anchorDate,
                                                intervalComponents: interval)
        
        // Result and update handlers
        query.initialResultsHandler = {
            query, statisticsCollection, error in
            if let stat = statisticsCollection {
                self.updateUI(stat, startDate: beginningOfWeek, endDate: endOfWeek)
            }
        }
        query.statisticsUpdateHandler = { query, statistics,
            statisticsCollection, error in
            if let stat = statisticsCollection {
                self.updateUI(stat, startDate: beginningOfWeek, endDate: endOfWeek)
            }
        }
        
        // Execute query on health store
        HealthData.healthStore.execute(query)
    }
    
    class func updateUI(_ statisticsCollection: HKStatisticsCollection, startDate: Date, endDate: Date) {
        // Update chart UI
        DispatchQueue.main.async {
            
            let group = DispatchGroup()
            var dataVals: [CGFloat] = []
            
//            guard let adjStart = Calendar.current.date(byAdding: DateComponents(day: 0), to: startDate),
//                  let adjEnd = Calendar.current.date(byAdding: DateComponents(day: 0), to: endDate) else {
//                fatalError("*** Invalid date range ***")
//            }
            
            group.enter()
            statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
                
                let toAdd = statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0.0
                dataVals.append(CGFloat(toAdd))
                
                if dataVals.count >= 7 {
                    group.leave()
                }
            }
            
            group.wait()
            self.graphValues = [
                OCKDataSeries(values: dataVals, title: "Step Count")
            ]
            print(self.graphValues)
            
            // Update graph values in view controller
            self.controller?.chartView.graphView.dataSeries = HealthData.graphValues
        }
    }
}
