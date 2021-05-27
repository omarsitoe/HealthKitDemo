//
//  SurveyView.swift
//  HealthKitDemo
//
//  Created by Omar Trejo on 5/23/21.
//

import Foundation
import SwiftUI
import CareKit

struct SurveyView: UIViewControllerRepresentable {
    
    @Environment(\.storeManager) private var manager
    
    typealias UIViewControllerType = SurveyViewController

    func makeUIViewController(context: Context) -> SurveyViewController {
        let surveyCard = SurveyViewController(
            taskID: "diabetes",
            eventQuery: OCKEventQuery(for: Date()),
            storeManager: manager)
        
        return surveyCard
    }

    func updateUIViewController(_ uiView: SurveyViewController, context: Context) {
        
    }
}
