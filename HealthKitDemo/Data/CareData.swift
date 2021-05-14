//
//  CareData.swift
//  HealthKitDemo
//
//  Created by Omar Trejo on 5/13/21.
//

import Foundation
import CareKit

let storeName = "com.utk.healthkitdemo.moca"

class CareData {
    static let careStore: OCKStore = OCKStore(name: storeName)
    
    init() {
        CareData.TaskCreator()
    }
    
    // MARK: - Task Manager
    
    class func TaskCreator() {
        // Build schedule for 10 am every day
        // FIXME: Possibly make sure calendar adjusts to user preference
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let inTheMorning = Calendar.current.date(byAdding: .hour, value: 10, to: startOfDay)!

        let dailyMorning = OCKScheduleElement(start: inTheMorning, end: nil, interval: DateComponents(day: 1))

        let schedule = OCKSchedule(composing: [dailyMorning])
        
        // Build questionnaire task
        var task = OCKTask(id: "diabetes questionnaire", title: "Daily Check In", carePlanID: nil, schedule: schedule)
        

        task.instructions = "Answer the folllowing questions to the best of your ability."
        
        // Add task to store
        careStore.addTasks([task],
           callbackQueue: DispatchQueue.main,
                completion: { (result: (Result<[OCKTask], OCKStoreError>)) in
                         switch result {
                         case .failure(let error) :
                             print(error.localizedDescription)
                         case .success( _) :
                             print("Success!")
                         }
         })
    }
    
}
