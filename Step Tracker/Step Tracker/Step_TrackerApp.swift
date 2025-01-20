//
//  Step_TrackerApp.swift
//  Step Tracker
//
//  Created by Jack Ziegenhorn on 8/17/24.
//

import SwiftUI

@main
struct Step_TrackerApp: App {
    let hkManager = HealthKitManager()
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environment(hkManager)
        }
    }
}
