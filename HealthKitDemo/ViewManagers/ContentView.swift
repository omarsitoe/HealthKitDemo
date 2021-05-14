//
//  ContentView.swift
//  HealthKitDemo
//
//  Created by Omar Trejo on 5/9/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("How calm, rested, relaxed do you feel today?")
                Text("(answer 1 = totally, 5 = not at all")
            }
            //.background(Color.purple)
            .padding(.bottom, 50)
            VStack(alignment: .leading) {
                Text("Have you been able to keep up with your diabetes care?")
                Text("(answer 1 = totally, 5 = not at all)")
            }
            //.background(Color.red)
        }
        .padding(.leading, 30)
        .padding(.trailing, 30)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
            
    }
}
