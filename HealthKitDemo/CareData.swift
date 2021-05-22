//
//  CareData.swift
//  HealthKitDemo
//
//  Created by Omar Trejo on 5/13/21.
//

import Foundation
import CareKit
import CareKitStore

//let storeName = "com.utk.healthkitdemo.moca"

public class CareData {
    static let careStore: SurveyStore = SurveyStore()
    
    
    // MARK: - Task Manager
    
    // Creates sample task
    class func SurveyTaskCreator(question1: String, question2: String) -> SurveyTask {
        // Build schedule for 10 am every day
        // FIXME: Possibly make sure calendar adjusts to user preference
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let inTheMorning = Calendar.current.date(byAdding: .hour, value: 10, to: startOfDay)!

        let dailyMorning = OCKScheduleElement(start: inTheMorning, end: nil, interval: DateComponents(day: 1))

        let schedule = OCKSchedule(composing: [dailyMorning])
        
        // Build questionnaire task
        //var task = OCKTask(id: "diabetes questionnaire", title: "Daily Check In", carePlanID: nil, schedule: schedule)
        var task = SurveyTask(id: "diabetes questionnaire", title: "Daily Check In", carePlanID: nil, schedule: schedule)
        

        task.instructions = "Answer the folllowing questions to the best of your ability."
        task.setUpSurvey(question1: question1, question2: question2)
        
        //JUST FOR TESTING
        task.setScore1(score1: 3)
        task.setScore2(score2: 4)
        ///
        
        // Add task to store
        careStore.addTasks([task],
           callbackQueue: DispatchQueue.main,
                completion: { (result: (Result<[SurveyTask], OCKStoreError>)) in
                         switch result {
                         case .failure(let error) :
                             print(error.localizedDescription)
                         case .success( _) :
                             print("Success!")
                         }
         })
        
        return task
    }
}
