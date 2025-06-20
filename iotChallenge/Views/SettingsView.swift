//
//  SettingsView.swift
//  iotChallenge
//
//  Created by Teryl S on 6/19/25.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Account")) {
                    NavigationLink("Profile", destination: Text("Profile Settings"))
                    NavigationLink("Notifications", destination: Text("Notification Settings"))
                }

                Section(header: Text("App Settings")) {
                    Toggle("Dark Mode", isOn: .constant(false))
                    NavigationLink("App Version", destination: Text("1.0.0"))
                }

                Section {
                    Button("Sign Out", role: .destructive) {
                        print("Signing out…")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
