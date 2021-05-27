//
//  SurveyView.swift
//  HealthKitDemo
//
//  Created by Omar Trejo on 5/23/21.
//

import Foundation
import SwiftUI
import CareKit
import ResearchKit
import UIKit

struct CardView: OCKCardable {
    var cardView: UIView
    var contentView: UIView
}

struct ContentView: View {
    
    @Environment(\.storeManager) private var manager
    
    public var body: some View {
        VStack {
            Text("Hello")
//            CardView {
//                InstructionsTaskView(
//                    taskID: "question1",
//                    eventQuery: OCKEventQuery(for: Date()),
//                    storeManager: manager)
//                SurveyView()
//            }
            
            //CardView(cardView: .init(), contentView: .init())
        }
    }
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
