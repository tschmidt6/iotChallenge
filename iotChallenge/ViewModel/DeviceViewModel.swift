//
//  DeviceViewModel.swift
//  iotChallenge
//
//  Created by Teryl S on 6/19/25.
//
import Combine
import Foundation
import SwiftUI

struct Device: Identifiable, Equatable, Decodable {
    let id: String
    let name: String?
    var isConnected: Bool?
    let type: String
    var status: String?
    var alert: String?
    var battery: Int?
    var fuelLevel: Int?
    var isLightOn: Bool
    var runtimeLeft: String?
}

class DeviceViewModel: ObservableObject {
    @Published var devices: [Device] = []

    private let webSocket = MowerWebSocket()

    init() {
        webSocket.onMessage = { [weak self] message in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.updateDevice(from: message)
            }
        }
        webSocket.connect()
    }
    
    private func updateDevice(from message: DeviceMessage) {
        if let index = devices.firstIndex(where: { $0.id == message.id }) {
            // Update existing device
            var device = devices[index]
            device.isConnected = message.isConnected ?? message.isConnected
            device.status = message.status ?? device.status
            device.alert = message.alert ?? device.alert
            device.battery = message.battery ?? device.battery
            device.fuelLevel = message.fuelLevel ?? device.fuelLevel
            device.isLightOn = message.isLightOn ?? device.isLightOn
            device.runtimeLeft = message.runtimeLeft ?? device.runtimeLeft
            devices[index] = device
        } else {
            // Create new device
            let newDevice = Device(
                id: message.id,
                name: message.name,
                isConnected: message.isConnected,
                type: message.device,
                status: message.status,
                alert: message.alert,
                battery: message.battery,
                fuelLevel: message.fuelLevel,
                isLightOn: message.isLightOn ?? false,
                runtimeLeft: message.runtimeLeft
            )
            devices.append(newDevice)
        }
    }
    
    func sendCommand(to device: String, command: String) {
        let message = ["device": device, "command": command]
        if let data = try? JSONSerialization.data(withJSONObject: message) {
            webSocket.send(message: data)
        }
    }
    
    func addDevice(fromQRCode string: String) {
        // Parse string (UUID or JSON) to create Device
        if let data = string.data(using: .utf8),
           let decoded = try? JSONDecoder().decode(Device.self, from: data) {
            devices.append(decoded)
        } else {
            // fallback: assume string is just UUID or name
            let newDevice = Device(id: UUID().uuidString, name: "New Device", type: "unknown", isLightOn: false) // customize
            devices.append(newDevice)
        }
    }
}
