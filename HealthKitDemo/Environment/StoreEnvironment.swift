//
//  StoreEnvironment.swift
//  HealthKitDemo
//
//  Created by Omar Trejo on 5/23/21.
//

import Foundation
import CareKit
import SwiftUI

private struct StoreManagerEnvironmentKey: EnvironmentKey {

    static var defaultValue: OCKSynchronizedStoreManager {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.storeManager
    }
}

public extension EnvironmentValues {

    var storeManager: OCKSynchronizedStoreManager {
        get { self[StoreManagerEnvironmentKey.self] }
        set { self[StoreManagerEnvironmentKey.self] = newValue }
    }
}
