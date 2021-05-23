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

struct SurveyView: View {
    
    let store = CareData.careStore
    let manager = OCKSynchronizedStoreManager(wrapping: CareData.careStore)
    
    var body: some View {
        Text("Hello!")
    }
}

struct SurveyView_Preview: PreviewProvider {
    static var previews: some View {
        SurveyView()
    }
}
