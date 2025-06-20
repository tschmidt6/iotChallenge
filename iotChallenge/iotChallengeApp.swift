//
//  iotChallengeApp.swift
//  iotChallenge
//
//  Created by Teryl S on 6/19/25.
//

import SwiftUI

@main
struct iotChallengeApp: App {
    
    @StateObject private var viewModel = DeviceViewModel()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                DashboardView(viewModel: viewModel)
                    .tabItem {
                        Label("Dashboard", systemImage: "house.fill")
                    }
                
                DevicesView(viewModel: viewModel)
                    .tabItem {
                        Label("Devices", systemImage: "dot.radiowaves.left.and.right")
                    }
                
                AlertsView(viewModel: viewModel)
                    .tabItem {
                        Label("Alerts", systemImage: "exclamationmark.triangle.fill")
                    }
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape")
                    }
            }
            .accentColor(.green)
        }
    }
}
