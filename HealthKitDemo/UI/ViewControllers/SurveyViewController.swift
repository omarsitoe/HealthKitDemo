//
//  SurveyViewController.swift
//  HealthKitDemo
//
//  Created by Omar Trejo on 5/22/21.
//

import Foundation
import CareKit
import ResearchKit
import UIKit


// MARK: ResearchKit-Compatible View Controller
class SurveyViewController: OCKInstructionsTaskViewController, ORKTaskViewControllerDelegate {

    // Called when the user taps the button!
    override func taskView(_ taskView: UIView & OCKTaskDisplayable, didCompleteEvent isComplete: Bool, at indexPath: IndexPath, sender: Any?) {

        // If the task was marked incomplete, fall back on the
        // super class's default behavior or deleting the outcome.
        if !isComplete {
            super.taskView(taskView, didCompleteEvent: isComplete, at: indexPath, sender: sender)
            return
        }

        // If the user attempted to mark the task complete,
        // display a ResearchKit survey.
        let answerFormat = ORKAnswerFormat.scale(withMaximumValue: 5, minimumValue: 1, defaultValue: 3, step: 1, vertical: false,
                                                 maximumValueDescription: "Totally", minimumValueDescription: "Not at all")
        let feelStep = ORKQuestionStep(identifier: "question1",
                                       title: "How Do You Feel Today",
                                       question: "How calm, rested, relaxed do you feel today?",
                                       answer: answerFormat)
        let routineStep = ORKQuestionStep(identifier: "question2",
                                          title: "How Is Your Treatment Going",
                                          question: "Have you been able to keep up with your diabetes care?",
                                          answer: answerFormat)
        
        let surveyTask = ORKOrderedTask(identifier: "survey",
                                        steps: [feelStep, routineStep])
        let surveyViewController = ORKTaskViewController(task: surveyTask, taskRun: nil)
        surveyViewController.delegate = self
        

        // Present the survey to the user
        present(surveyViewController, animated: false, completion: nil)
    }

    // Called when the user completes the survey.
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        taskViewController.dismiss(animated: true, completion: nil)
        guard reason == .completed else {
            taskView.completionButton.isSelected = false
            return
        }

        // Retrieves the result from the ResearchKit survey
        let survey1 = taskViewController.result.results!.first(where: { $0.identifier == "question1" }) as! ORKStepResult
        
        let questionResult1 = survey1.results!.first as! ORKScaleQuestionResult
        let answer1 = Int(truncating: questionResult1.scaleAnswer!)
        
        // Second answer
//        let survey2 = taskViewController.result.results!.first(where: { $0.identifier == "question2" }) as! ORKStepResult
//
//        let questionResult2 = survey2.results!.first as! ORKScaleQuestionResult
//        let answer2 = Int(truncating: questionResult2.scaleAnswer!)
        
        
        // Saves the result into CareKit's store
        controller.appendOutcomeValue(withType: answer1, at: IndexPath(item: 0, section: 0), completion: { (result: (Result<OCKAnyOutcome, Error>)) in
            switch result {
            case .failure(let error) :
                print(error.localizedDescription)
            case .success( _) :
                print("first value added!")
            }
        })
        
//        controller.appendOutcomeValue(withType: answer2, at: IndexPath(item: 0, section: 0), completion: { (result: (Result<OCKAnyOutcome, Error>)) in
//            switch result {
//            case .failure(let error) :
//                print(error.localizedDescription)
//            case .success( _) :
//                print("second value added!")
//            }
//        })
    }
}


// MARK: Custom View Synchronizer
class SurveyViewSynchronizer: OCKInstructionsTaskViewSynchronizer {

    // Customize the initial state of the view
    override func makeView() -> OCKInstructionsTaskView {
        let instructionsView = super.makeView()
        instructionsView.completionButton.label.text = "Start Survey"
        return instructionsView
    }

    // Customize how the view updates
    override func updateView(_ view: OCKInstructionsTaskView,
                             context: OCKSynchronizationContext<OCKTaskEvents?>) {
        super.updateView(view, context: context)

        // Check if an answer exists or not and set the detail label accordingly
        print("first line = \(String(describing: context.viewModel?.event(forIndexPath: IndexPath(item: 0, section: 0))?.outcome?.values.first?.integerValue ))")
        print("second line = \(String(describing: context.viewModel?.event(forIndexPath: IndexPath(item: 0, section: 0))?.outcome?.values ))")
        let answer2 = -1
        if let answer1 = context.viewModel?.firstEvent?.outcome?.values.first?.integerValue {
            view.headerView.detailLabel.text = "Answer 1: \(answer1) \nAnswer 2: \(answer2)"
        } else {
            view.headerView.detailLabel.text = "How is treatment going?"
        }
    }
}
