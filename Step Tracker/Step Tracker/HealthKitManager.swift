//
//  HealthKitManager.swift
//  Step Tracker
//
//  Created by Jack Ziegenhorn on 1/19/25.
//

import Foundation
import HealthKit

@Observable class HealthKitManager {
    let store = HKHealthStore()
    let types: Set = [HKQuantityType(.stepCount), HKQuantityType(.bodyMass)]

}
