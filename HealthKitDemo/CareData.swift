//
//  CareData.swift
//  HealthKitDemo
//
//  Created by Omar Trejo on 5/13/21.
//

import Foundation
import CareKit
import CareKitStore

let storeName = "com.utk.healthkitdemo.moca"

public class CareData {
    
    static let careStore: OCKStore = OCKStore(name: storeName)
    
    
    // MARK: - Task Manager
    
    // Creates sample task
    class func TaskCreator(id: String) {
        // Build schedule for 10 am every day
        // FIXME: Possibly make sure calendar adjusts to user preference
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let inTheMorning = Calendar.current.date(byAdding: .hour, value: 10, to: startOfDay)!

        let dailyMorning = OCKScheduleElement(start: inTheMorning, end: nil, interval: DateComponents(day: 1))

        let schedule = OCKSchedule(composing: [dailyMorning])
        
        // Build questionnaire task
        var task = OCKTask(id: id, title: "Daily Check In", carePlanID: nil, schedule: schedule)
        
        task.instructions = "Answer daily survey"
        
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
    
    class func SurveyTaskCreator(question1: String, question2: String) {
        // Build schedule for 10 am every day
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let inTheMorning = Calendar.current.date(byAdding: .hour, value: 10, to: startOfDay)!

        let dailyMorning = OCKScheduleElement(start: inTheMorning, end: nil, interval: DateComponents(day: 1))

        _ = OCKSchedule(composing: [dailyMorning])
        
        // Create two survey tasks
        //var task = SurveyTask(id: "diabetes questionnaire", title: "Daily Check In", carePlanID: nil, schedule: schedule)
        
        // Add tasks to the store
    
    }
}
