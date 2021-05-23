//
//  SurveyViewController.swift
//  HealthKitDemo
//
//  Created by Omar Trejo on 5/22/21.
//

import Foundation
import CareKit
import ResearchKit

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
        
        let surveyTask = ORKOrderedTask(identifier: "question1", steps: [feelStep])
        let surveyViewController = ORKTaskViewController(task: surveyTask, taskRun: nil)
        surveyViewController.delegate = self
        

        // Present the survey to the user
        present(surveyViewController, animated: true, completion: nil)
    }

    // Called when the user completes the survey.
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        taskViewController.dismiss(animated: true, completion: nil)
        guard reason == .completed else {
            taskView.completionButton.isSelected = false
            return
        }

        // Retrieves the result from the ResearchKit survey
        let survey = taskViewController.result.results!.first(where: { $0.identifier == "question1" }) as! ORKStepResult
        let questionResult = survey.results!.first as! ORKScaleQuestionResult
        let answer = Int(truncating: questionResult.scaleAnswer!)

        // Saves the result into CareKit's store
        controller.appendOutcomeValue(withType: answer, at: IndexPath(item: 0, section: 0), completion: nil)
    }
}
