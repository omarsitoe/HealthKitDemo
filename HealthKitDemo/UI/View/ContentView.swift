//
//  SurveyView.swift
//  HealthKitDemo
//
//  Created by Omar Trejo on 5/23/21.
//

import Foundation
import SwiftUI
import CareKit
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
        }
    }
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
