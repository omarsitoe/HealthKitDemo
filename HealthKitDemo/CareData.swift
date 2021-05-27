//
//  CareData.swift
//  HealthKitDemo
//
//  Created by Omar Trejo on 5/13/21.
//

import Foundation
import CareKit
import CareKitStore



public class CareData {
    
    // MARK: - Task Manager
    
    class func TaskCreator(id: String, careStore: OCKStore) {
        // Build schedule for 10 am every day
        // FIXME: Possibly make sure calendar adjusts to user preference
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let inTheMorning = Calendar.current.date(byAdding: .hour, value: 10, to: startOfDay)!

        let dailyMorning = OCKScheduleElement(start: inTheMorning, end: nil, interval: DateComponents(day: 1))

        let schedule = OCKSchedule(composing: [dailyMorning])
        
        // Build questionnaire task
        var task = OCKTask(id: id, title: "Daily Check In", carePlanID: nil, schedule: schedule)
        
        task.instructions = "Answer daily survey"
        task.impactsAdherence = true
        
        //Clean store
        //FIXME: Remove in final. Just for debugging
//        careStore.fetchTask(withID: "diabetes", completion:{ (result: (Result<OCKTask, OCKStoreError>)) in
//            switch result {
//            case .failure( _) :
//                print("Task not found! Adding...")
//                careStore.addTasks([task],
//                   callbackQueue: DispatchQueue.main,
//                        completion: { (result1: (Result<[OCKTask], OCKStoreError>)) in
//                                 switch result1 {
//                                 case .failure(let error) :
//                                     print(error.localizedDescription)
//                                 case .success( _) :
//                                     print("Added!")
//                                 }
//                 })
//            case .success( _) :
//                print("Task already exists! :)")
//                if let toBeDeleted: OCKTask = try? result.get() {
//                    print("DELETING HOPEFULLY!")
//                    careStore.deleteTask(toBeDeleted)
//                }
//            }
//        })
        
        // Add task to store
        careStore.addTask(task,
           callbackQueue: DispatchQueue.main,
                completion: { (result: (Result<OCKTask, OCKStoreError>)) in
                         switch result {
                         case .failure(let error) :
                             print(error.localizedDescription)
                         case .success( _) :
                             print("Success!")
                         }
         })
    }
}
