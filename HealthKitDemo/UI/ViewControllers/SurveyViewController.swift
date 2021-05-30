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


// MARK: - ResearchKit-Compatible View Controller
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
        
        // Create and format survey questions
        let answerFormat = ORKAnswerFormat.scale(withMaximumValue: 5, minimumValue: 1, defaultValue: 3, step: 1, vertical: false,
                                                 maximumValueDescription: "Totally", minimumValueDescription: "Not at all")
        
        let surveyForm = ORKFormStep(identifier: "surveyForm",
                                     title: "Form", text: "Daily Check In")
        
        let item1 = ORKFormItem(identifier: "question1",
                                text: "How Calm or Relaxed Do You Feel Today",
                                answerFormat: answerFormat)
        let item2 = ORKFormItem(identifier: "question2",
                                text: "How Have You Kept Up With Your Diabetes Care",
                                answerFormat: answerFormat)
        
        surveyForm.formItems = [item1, item2]
        
        let surveyTask = ORKOrderedTask(identifier: "survey", steps: [surveyForm])
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
        let survey = taskViewController.result.results!.first(where: { $0.identifier == "surveyForm" }) as! ORKStepResult
        
        let questionResult1 = survey.results!.first(where: { $0.identifier == "question1" })  as! ORKScaleQuestionResult
        let answer1 = Int(truncating: questionResult1.scaleAnswer!)
        
        let questionResult2 = survey.results!.first(where: { $0.identifier == "question2" })  as! ORKScaleQuestionResult
        let answer2 = Int(truncating: questionResult2.scaleAnswer!)
        
        print("ANSWERS:")
        print(answer1)
        print(answer2)
        print()
        
        // Saves the result into CareKit's store
        if let event = controller.eventFor(indexPath: IndexPath(item: 0, section: 0)) {

            //FIXME: Values might not be saved in order? Make sure
            let values = [answer1, answer2].map { OCKOutcomeValue($0) }
            let outcome = try! controller.makeOutcomeFor(event: event, withValues: values)

            controller.storeManager.store.addAnyOutcome(outcome, callbackQueue: .main) { result in
                switch result {
                case let .success(updatedOutcome):
                    print("Success: \(updatedOutcome.values)")
                case let .failure(error):
                    print("Error: \(error)")
                }
            }
        }
    }
}


// MARK: - Custom View Synchronizer
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
        if let answers = context.viewModel?.event(forIndexPath: IndexPath(item: 0, section: 0))?.outcome?.values {
            view.headerView.detailLabel.text = "Answers: \(answers)"
        } else {
            view.headerView.detailLabel.text = "How is treatment going?"
        }
    }
}
