//
//  DevicesView.swift
//  iotChallenge
//
//  Created by Teryl S on 6/19/25.
//

import SwiftUI

struct DevicesView: View {
    @ObservedObject var viewModel: DeviceViewModel
    
    @State private var showingScanner = false

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Connected Devices")) {
                    ForEach(viewModel.devices) { device in
                        Text(device.name ?? "Unknown Device")
                    }
                }

                Section(header: Text("Add New Device")) {
                    Button("Scan for Devices") {
                        print("Scanning…")
                    }
                    Button("Add Device via QR Code") {
                        showingScanner = true
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Devices")
            .sheet(isPresented: $showingScanner) {
                QRScannerSheet { scannedValue in
                    viewModel.addDevice(fromQRCode: scannedValue)
                }
            }
        }
    }
}

struct DevicesView_Previews: PreviewProvider {
    @State static var viewModel: DeviceViewModel = DeviceViewModel()
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
        DevicesView(viewModel: viewModel).onAppear {
            viewModel.devices = [lawnmower, generator]
        }
    }
}
