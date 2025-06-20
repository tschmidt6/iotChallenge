//
//  DashboardView.swift
//  iotChallenge
//
//  Created by Teryl S on 6/19/25.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: DeviceViewModel

    var body: some View {
        NavigationStack {
            List(viewModel.devices) { device in
                Section {
                    NavigationLink(destination: DeviceDetailView(device: device, viewModel: viewModel)) {
                        DeviceRowView(device: device)
                    }
                }
            }
            .navigationTitle("Smart Devices")
        }
    }
}


struct DeviceRowView: View {
    let device: Device

    var body: some View {
        VStack {
            HStack(spacing: 16) {
                // Device image
                Image(device.type)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 20) {
                        // Device name
                        Text("\(device.name ?? "Unnamed Device")")
                            .font(.headline)
                        
                        // Connected
                        if device.isConnected ?? false {
                            Image(systemName: "dot.radiowaves.left.and.right")
                                .foregroundStyle(.green)
                                .frame(width: 10, height: 10)
                        } else {
                            Image(systemName: "dot.radiowaves.left.and.right")
                                .foregroundStyle(.red)
                                .frame(width: 10, height: 10)
                        }
                        
                        
                    }
                    HStack {
                        // Battery or Fuel level
                        if let battery = device.battery {
                            HStack {
                                Image(systemName: batteryIcon(for: battery))
                                Text("\(battery)%")
                                    .font(.subheadline)
                            }
                            .foregroundColor(battery > 20 ? .green : .red)
                            
                        } else if let fuel = device.fuelLevel {
                            HStack {
                                Image(systemName: "fuelpump.fill")
                                Text("\(fuel)%")
                                    .font(.subheadline)
                            }
                            .foregroundColor(fuel > 20 ? .green : .red)
                        }
                        
                        // Task Light
                        HStack {
                            Image(systemName: device.isLightOn ? "lightbulb.fill" : "lightbulb")
                            Text("\(device.isLightOn ? "ON" : "OFF")")
                                .font(.subheadline)
                        }
                        .foregroundColor(device.isLightOn ? .yellow : .gray)
                    }
                    
                    // Runtime Left
                    Text("Runtime left: \(device.runtimeLeft ?? "Unknown")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Device Status
                    Text("Status: \(device.status ?? "Unknown")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                }
                Spacer()
            }
            .padding(.vertical, 8)
        }
    }
    
    func batteryIcon(for level: Int) -> String {
        switch level {
        case 0...10:
            return "battery.0"
        case 11...25:
            return "battery.25"
        case 26...50:
            return "battery.50"
        case 51...75:
            return "battery.75"
        default:
            return "battery.100"
        }
    }
}

struct DeviceRowView_Previews: PreviewProvider {
    static let lawnmower = Device(
        id: "1",
        name: "40V Lawnmower",
        isConnected: true,
        type: "lawnmower",
        status: "Charging",
        alert: nil,
        battery: 75,
        fuelLevel: 0,
        isLightOn: true,
        runtimeLeft: "1h 30m"
    )
    static let generator = Device(
        id: "2",
        name: "40V 1800W Generator",
        isConnected: false,
        type: "generator",
        status: "Idle",
        alert: "Low Fuel",
        battery: nil,
        fuelLevel: 20,
        isLightOn: false,
        runtimeLeft: "3h 20m"
    )
    
    static var previews: some View {
        Group {
            DeviceRowView(device: lawnmower)
            .previewLayout(.sizeThatFits)
            .padding()

            DeviceRowView(device: generator)
            .previewLayout(.sizeThatFits)
            .padding()
            .preferredColorScheme(.dark)
        }
    }
}
