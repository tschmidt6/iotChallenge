//
//  AlertsView.swift
//  iotChallenge
//
//  Created by Teryl S on 6/19/25.
//

import SwiftUI

struct AlertsView: View {
    @ObservedObject var viewModel: DeviceViewModel

    var body: some View {
        NavigationStack {
            List(viewModel.devices) { device in
                Section(header: Text("\(device.name ?? "No Name") Alerts")) {
                    Text("⚠️ \(device.alert ?? "No Alerts")")
                        .foregroundColor(.red)
                        .font(.body)
                }
            }
            .navigationTitle("Alerts")
        }
    }
}

struct AlertRow: View {
    let title: String
    let message: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundColor(color)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}
