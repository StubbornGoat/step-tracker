//
//  HealthKitPermissionIntroView.swift
//  Step Tracker
//
//  Created by Jack Ziegenhorn on 1/19/25.
//

import SwiftUI
import HealthKitUI

struct HealthKitPermissionIntroView: View {
    @Environment(HealthKitManager.self) private var hkManager
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingHealthKitPermissionAlert: Bool = false
    var description = """
This app displays your step and weight data in interactive charts.

You can also add new step or weight data to Apple Health from this app. Your data is private and secured.
"""
    
    var body: some View {
        VStack(spacing: 130) {
            VStack(alignment: .leading, spacing: 12) {
                Image(.appleHealth)
                    .resizable()
                    .frame(width: 90, height: 90)
                    .shadow(color: .gray.opacity(0.3), radius: 10)
                    .padding(.bottom, 12)
                
                Text("Apple Health Integration")
                    .font(.title2).bold()
                Text(description)
                    .foregroundStyle(.secondary)
            }

            Button("Connect Apple Health") {
                isShowingHealthKitPermissionAlert = true
            }
            .buttonStyle(.borderedProminent)
            .tint(.pink)
        }
        .padding(30)
        .healthDataAccessRequest(
            store: hkManager.store,
            shareTypes: hkManager.types,
            readTypes: hkManager.types,
            trigger: isShowingHealthKitPermissionAlert) { result in
                switch result {
                case .success:
                    dismiss()
                case .failure:
                    //handle error later
                    dismiss()
                }
            }
    }
}


#Preview {
    HealthKitPermissionIntroView()
        .environment(HealthKitManager())
}
