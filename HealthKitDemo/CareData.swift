//
//  CareData.swift
//  HealthKitDemo
//
//  Created by Omar Trejo on 5/13/21.
//

import Foundation
import CareKit
import HealthKit
import UIKit
import Contacts

class CareData {
    
    var careStore: OCKStore
    init(store: OCKStore) {
        self.careStore = store
    }
    
    // MARK: - Task Manager
    func TaskCreator() {
        // Build schedule for 10 am every day
        // FIXME: Possibly make sure calendar adjusts to user preference
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let inTheMorning = Calendar.current.date(byAdding: .hour, value: 10, to: startOfDay)!

        let dailyMorning = OCKScheduleElement(start: inTheMorning, end: nil, interval: DateComponents(day: 1))

        let schedule = OCKSchedule(composing: [dailyMorning])
        
        // Build questionnaire task
        var task = OCKTask(id: "diabetes", title: "Daily Check In", carePlanID: nil, schedule: schedule)
        
        task.instructions = "Answer daily survey"
        task.impactsAdherence = true
        
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
    
    //MARK: - Dummy Contact List Creator
    func PopulateContactList() {
        //clean store timeline for debugging
//        careStore.fetchContacts(completion: {
//            result in
//                switch result {
//                case let .success(Contacts):
//                    print("Success: \(Contacts)")
//                    self.careStore.deleteContacts(Contacts)
//                case let .failure(error):
//                    print("Error: \(error)")
//                }
//        })
        
        //Create dummy contact
        var contact = OCKContact(id: "omar", givenName: "Omar",
                                 familyName: "Trejo", carePlanID: nil)
        contact.asset = "OmarTrejo"
        contact.title = "Family Physician"
        contact.role = "Doctor with - years of experience"
        contact.emailAddresses = [OCKLabeledValue(label: CNLabelEmailiCloud, value: "otrejome@vols.utk.edu")]
        contact.phoneNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(352) 631-3931")]
        contact.messagingNumbers = [OCKLabeledValue(label: CNLabelWork, value: "(352) 631-3931")]

        contact.address = {
            let address = OCKPostalAddress()
            address.street = "1502 Cumberland Ave"
            address.city = "Knoxville"
            address.state = "TN"
            address.postalCode = "37996"
            return address
        }()
        
        //Add to the store
        careStore.addContacts([contact])
    }
}
