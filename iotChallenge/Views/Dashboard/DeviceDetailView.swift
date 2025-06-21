//
//  DeviceDetailView.swift
//  iotChallenge
//
//  Created by Teryl S on 6/20/25.
//

import SwiftUI

struct DeviceDetailView: View {
    let device: Device
    @ObservedObject var viewModel: DeviceViewModel
    
    @State var isPowerOn: Bool = false
    @State var isLightOn: Bool = false
    @State var backLight: Int = 0

    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    // Device image
                    Image(device.type)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    Spacer()
                    VStack {
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
                        Spacer()
                    }
                }
            }
            
            // Details
            Section {
                // Device status and Alerts
                Text("Status: \(device.status ?? "Unknown")")
                
                // Battery & Fuel
                if let battery = device.battery {
                    Text("Battery Level: \(battery)%")
                    Text("Time to Fully Charge: 45 min")
                }
                if let fuel = device.fuelLevel {
                    Text("Fuel Level: \(fuel)%")
                }
                
                Text("Runtime Left: \(device.runtimeLeft ?? "00:00")")
                
            }
            // Light
            Section {
                Toggle(isOn: $isLightOn) {
                    HStack {
                        Text("Task Light")
                        Spacer()
                        Image(systemName: isLightOn ? "lightbulb.fill" : "lightbulb")
                            .foregroundColor(isLightOn ? .yellow : .gray)
                    }
                    
                }.onChange(of: isLightOn) {
                    let command = isLightOn ? "on" : "off"
                    viewModel.sendCommand(to: device.type, command: command)
                }
                HStack {
                    Text("LCD Backlight")
                    Picker("", selection: $backLight) {
                        Text("OFF").tag(0)
                        Text("LOW").tag(1)
                        Text("HIGH").tag(2)
                    }
                    .pickerStyle(.segmented)
                }
            }
            // Turn the device on or off remotely
            Section {
                Toggle(isOn: $isPowerOn) {
                    Text("Shutdown")
                }.onChange(of: isPowerOn, {
                    viewModel.sendCommand(to: device.type, command: "shutdown")
                })
            }
            
            // Troubleshooting
            Section {
                NavigationLink("View Manual") {
                    PDFViewerView(pdfName: "manual")
                }
                NavigationLink(destination: EmptyView()) {
                    Text("Settings")
                }
                NavigationLink(destination: EmptyView()) {
                    Text("Logs")
                }
            }
        }
        .navigationTitle("\(device.type.capitalized) Details")
    }
}

struct DeviceDetialView_Previews: PreviewProvider {
    @StateObject static var viewModel: DeviceViewModel = DeviceViewModel()
    static let lawnmower = Device(
        id: "1",
        name: "40V Lawnmower",
        isConnected: true,
        type: "lawnmower",
        status: "Charging",
        alert: nil,
        battery: 75,
        fuelLevel: nil,
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
            DeviceDetailView(device: lawnmower, viewModel: viewModel)
            .previewLayout(.sizeThatFits)
            .padding()

            DeviceDetailView(device: generator, viewModel: viewModel)
            .previewLayout(.sizeThatFits)
            .padding()
            .preferredColorScheme(.dark)
        }
    }
}
