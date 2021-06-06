//
//  HealthData.swift
//  HealthKitDemo
//
//  Created by Omar Trejo on 6/5/21.
//

import Foundation
import HealthKit

class HealthData {
    
    var healthStore: HKHealthStore?
    var hkAvailable: Bool
    
    //MARK: - HKHealthStore Setup
    init() {
        // instantiate health store only if platform supports it
        hkAvailable = HKHealthStore.isHealthDataAvailable()
        if hkAvailable {
            healthStore = HKHealthStore()
        }
    }
    
    func InfoAuthorization() {
        let reqTypes = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!])
        
        healthStore?.requestAuthorization(toShare: reqTypes, read: reqTypes) { (success, error) in
            if !success {
                // Try again if failed
                //NOTE: failure does NOT mean user denied permission
                print("Something went wrong. Trying again...")
                self.InfoAuthorization()
            }
        }
    }
}
