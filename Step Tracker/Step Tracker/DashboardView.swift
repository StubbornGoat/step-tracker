//
//  DashboardView.swift
//  Step Tracker
//
//  Created by Jack Ziegenhorn on 8/17/24.
//

import SwiftUI

enum HealthMetricContext: CaseIterable, Identifiable{
    case steps,weight
    
    var id: Self {self}
    
    var title: String {
        switch self {
        case .steps:
            return "Steps"
        case .weight:
            return "weight"
        }
    }
    // add fractionLength here
}

struct DashboardView: View {
    @Environment(HealthKitManager.self) private var hkManager
    @State private var selectedStat: HealthMetricContext = .steps
    @State var showPermissionAlert: Bool = false
    var isSteps: Bool { selectedStat == .steps}
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Picker("Selected stat", selection: $selectedStat) {
                        ForEach(HealthMetricContext.allCases) {
                            Text($0.title)
                        }
                    }
                    .pickerStyle(.segmented)
                    VStack {
                        NavigationLink(value: selectedStat) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Label("Steps", systemImage: "figure.walk")
                                        .font(.title3.bold())
                                        .foregroundStyle(.pink)
                                    Text("Avg: 10K Steps")
                                        .font(.caption)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                            }
                        }
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 12)
                        
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.secondary)
                            .frame(height: 150)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
                    
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            Label("Averages", systemImage: "calendar")
                                .font(.title3.bold())
                                .foregroundStyle(.pink)
                            Text("Last 28 days")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.bottom, 12)
                        
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.secondary)
                            .frame(height: 240)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
                }
            }
            .padding()
            .task {
                //clean this up
                do {
                    if try await hkManager.store.statusForAuthorizationRequest(toShare: hkManager.types, read: hkManager.types) != .unnecessary {
                        showPermissionAlert = true
                    }
                } catch {
                    print("There was a problem checking authorization status: \(error.localizedDescription)")
                }
            }
            .navigationTitle("Dashboard")
            .navigationDestination(for: HealthMetricContext.self) { metric in
                HealthDataListView(metric: metric)
            }
            .sheet(
                isPresented: $showPermissionAlert,
                onDismiss: { // fetch health data
                },
                content: {HealthKitPermissionIntroView()}
            )
        }
        .tint(isSteps ? .pink : .indigo)
    }
}

#Preview {
    DashboardView()
        .environment(HealthKitManager())
}
