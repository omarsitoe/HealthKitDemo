//
//  TaskType.swift
//  HealthKitDemo
//
//  Created by Omar Trejo on 5/16/21.
//

import Foundation
import CareKit

struct SurveyTask: OCKAnyTask & Equatable & Identifiable {
    // MARK: OCKAnyTask
    let id: String
    var title: String?
    var instructions: String?
    var impactsAdherence: Bool
    var schedule: OCKSchedule
    var groupIdentifier: String?
    var remoteID: String?
    var notes: [OCKNote]?
    var carePlanID: OCKLocalVersionID?
    
    public init(id: String, title: String,
                carePlanID: OCKLocalVersionID?, schedule: OCKSchedule) {
        self.id = id
        self.title = title
        self.carePlanID = carePlanID
        self.schedule = schedule
        self.impactsAdherence = false
    }

    func belongs(to plan: OCKAnyCarePlan) -> Bool {
        return self.carePlanID?.description == plan.id
    }
    // Compare tasks by ID string
    static func == (lhs: SurveyTask, rhs: SurveyTask) -> Bool {
        return lhs.id == rhs.id
    }

    // MARK: Custom Task Properties and Setters
    public var surveyQuestion1: String?
    public var surveyQuestion2: String?
    private var surveyScore1: Int?
    private var surveyScore2: Int?
    
    mutating func setUpSurvey(question1: String, question2: String) {
        self.surveyQuestion1 = question1
        self.surveyQuestion2 = question2
    }
    
    func getQuestion(number: Int) -> String {
        switch number {
        case 1:
            return self.surveyQuestion1!
        case 2:
            return self.surveyQuestion2!
        default:
            return "ERROR: Invalid number passed"
        }
    }
    
    mutating func setScore1(score1: Int) {
        // check passed number
        if score1 < 0 || score1 > 5 {
            print("Score1 is not valid score")
            return
        }
        self.surveyScore1 = score1
    }
    
    mutating func setScore2(score2: Int) {
        // check passed number
        if score2 < 0 || score2 > 5 {
            print("Score1 is not valid score")
            return
        }
        self.surveyScore2 = score2
    }
}

struct SurveyTaskQuery: OCKAnyTaskQuery {
    public init() {}
    
    // MARK: OCKAnyTaskQuery
    var carePlanIDs: [String] = []
    var sortDescriptors: [OCKTaskSortDescriptor] = []
    var ids: [String] = []
    var remoteIDs: [String] = []
    var groupIdentifiers: [String] = []
    var dateInterval: DateInterval?
    var limit: Int?
    var offset: Int = 0

    // MARK: Custom Task Properties and Setters
    public var surveyQuestion1: String?
    public var surveyQuestion2: String?
    private var surveyScore1: Int?
    private var surveyScore2: Int?
}

class SurveyStore: OCKStoreProtocol {
    
    //MARK: Protocol Vars and Methods
    typealias Plan = OCKCarePlan
    typealias Contact = OCKContact
    typealias Patient = OCKPatient
    typealias Outcome = OCKOutcome
    typealias PlanQuery = OCKCarePlanQuery
    typealias ContactQuery = OCKContactQuery
    typealias PatientQuery = OCKPatientQuery
    typealias OutcomeQuery = OCKOutcomeQuery
    
    var carePlanDelegate: OCKCarePlanStoreDelegate?
    var contactDelegate: OCKContactStoreDelegate?
    var patientDelegate: OCKPatientStoreDelegate?
    var taskDelegate: OCKTaskStoreDelegate?
    var outcomeDelegate: OCKOutcomeStoreDelegate?
    
    
    //MARK: CarePlan Methods
    func fetchCarePlans(query: OCKCarePlanQuery, callbackQueue: DispatchQueue, completion: @escaping OCKResultClosure<[OCKCarePlan]>) {}
    
    func addCarePlans(_ plans: [Plan], callbackQueue: DispatchQueue, completion: OCKResultClosure<[Plan]>?) {}
    
    func updateCarePlans(_ plans: [Plan], callbackQueue: DispatchQueue, completion: OCKResultClosure<[Plan]>?) {}
    
    func deleteCarePlans(_ plans: [Plan], callbackQueue: DispatchQueue, completion: OCKResultClosure<[Plan]>?) {}
    
    //MARK: Contacts Store
    func fetchContacts(query: OCKContactQuery, callbackQueue: DispatchQueue, completion: @escaping OCKResultClosure<[OCKContact]>) {}
    
    func addContacts(_ contacts: [Contact], callbackQueue: DispatchQueue, completion: OCKResultClosure<[Contact]>?) {}
    
    func updateContacts(_ contacts: [Contact], callbackQueue: DispatchQueue, completion: OCKResultClosure<[Contact]>?) {}
    
    func deleteContacts(_ contacts: [Contact], callbackQueue: DispatchQueue, completion: OCKResultClosure<[Contact]>?) {}
    
    //MARK: Patient Store
    func fetchPatients(query: OCKPatientQuery, callbackQueue: DispatchQueue, completion: @escaping OCKResultClosure<[OCKPatient]>) {}
    
    func addPatients(_ patients: [Patient], callbackQueue: DispatchQueue, completion: OCKResultClosure<[Patient]>?) {}
    
    func updatePatients(_ patients: [Patient], callbackQueue: DispatchQueue, completion: OCKResultClosure<[Patient]>?) {}
    
    func deletePatients(_ patients: [Patient], callbackQueue: DispatchQueue, completion: OCKResultClosure<[Patient]>?) {}
    
    //MARK: Events Store
    func fetchEvents(taskID: String, query: OCKEventQuery, callbackQueue: DispatchQueue, completion: @escaping OCKResultClosure<[Event]>) {}
    
    func fetchEvent(forTask task: SurveyTask, occurrence: Int, callbackQueue: DispatchQueue, completion: @escaping OCKResultClosure<Event>) {}
    
    //MARK: Outcome Store
    func fetchOutcomes(query: OCKOutcomeQuery, callbackQueue: DispatchQueue, completion: @escaping OCKResultClosure<[OCKOutcome]>) {}
    
    func addOutcomes(_ outcomes: [Outcome], callbackQueue: DispatchQueue, completion: OCKResultClosure<[Outcome]>?) {}
    
    func updateOutcomes(_ outcomes: [Outcome], callbackQueue: DispatchQueue, completion: OCKResultClosure<[Outcome]>?) {}
    
    func deleteOutcomes(_ outcomes: [Outcome], callbackQueue: DispatchQueue, completion: OCKResultClosure<[Outcome]>?) {}
    
    func addUpdateOrDeleteTasks(addOrUpdate tasks: [SurveyTask], delete deleteTasks: [SurveyTask], callbackQueue: DispatchQueue, completion: ((Result<([SurveyTask], [SurveyTask], [SurveyTask]), OCKStoreError>) -> Void)?) {}
    
    
    // MARK: Custom Methods and Vars
    typealias Task = SurveyTask
    typealias TaskQuery = SurveyTaskQuery

    // MARK: Task CRUD Methods
    func fetchTasks(query: TaskQuery, callbackQueue: DispatchQueue, completion: @escaping OCKResultClosure<[Task]>) {
        fatalError("Task fetching not implemented")
    }
    func addTasks(_ tasks: [Task], callbackQueue: DispatchQueue, completion: OCKResultClosure<[Task]>?) {
        //Add task to store
        fatalError("Task adding not implemented")
    }
    func updateTasks(_ tasks: [Task], callbackQueue: DispatchQueue, completion: OCKResultClosure<[Task]>?) {
        fatalError("Task updating not implemented")
    }
    func deleteTasks(_ tasks: [Task], callbackQueue: DispatchQueue, completion: OCKResultClosure<[Task]>?) {
        fatalError("Task deletion not implemented")
    }
}
