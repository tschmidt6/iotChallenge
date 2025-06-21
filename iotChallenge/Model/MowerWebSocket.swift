//
//  MowerWebSocket.swift
//  iotChallenge
//
//  Created by Teryl S on 6/19/25.
//

import Foundation


struct DeviceMessage: Codable {
    let id: String
    let name: String?
    let device: String
    let isConnected: Bool?
    let battery: Int?
    let status: String?
    let fuelLevel: Int?
    let load: String?
    let alert: String?
    let runtimeLeft: String?
    let isLightOn: Bool?
}

struct WebSocketConfig {
    static var baseURL: String {
        #if DEBUG
        return "ws://[YOUR API]:8000/ws/devices" // Use your device IP to test
        #else
        return "wss://api.mydeviceserver.com/ws/devices" // Production
        #endif
    }
}

class MowerWebSocket {
    var webSocketTask: URLSessionWebSocketTask?
    var onMessage: ((DeviceMessage) -> Void)?

    func connect() {
        guard let url = URL(string: WebSocketConfig.baseURL) else { return }
        webSocketTask = URLSession(configuration: .default).webSocketTask(with: url)
        webSocketTask?.resume()
        listen()
    }

    private func listen() {
        webSocketTask?.receive { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                print("WebSocket receive error: \(error)")
                self.reconnect()
            case .success(let message):
                switch message {
                case .data(let data):
                    print("Received data: \(data.map { String(format: "%02x", $0) }.joined())")
                    if let deviceData = try? JSONDecoder().decode(DeviceMessage.self, from: data) {
                        DispatchQueue.main.async {
                            self.onMessage?(deviceData)
                        }
                    } else {
                        print("Could not decode message from data.")
                    }
                case .string(let text):
                    print("Received string: \(text)")
                    if let data = text.data(using: .utf8),
                       let deviceData = try? JSONDecoder().decode(DeviceMessage.self, from: data) {
                        DispatchQueue.main.async {
                            self.onMessage?(deviceData)
                        }
                    } else {
                        print("Could not decode message from string.")
                    }
                default:
                    print("Unsupported WebSocket message type.")
                }

                // Keep listening
                self.listen()
            }
        }
    }
    
    private func reconnect() {
        print("Attempting to reconnect...")
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            self.connect()
        }
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        webSocketTask = nil
    }
    
    func send(message: Data) {
        let wsMessage = URLSessionWebSocketTask.Message.data(message)
        webSocketTask?.send(wsMessage) { error in
            if let error = error {
                print("Send error: \(error)")
            } else {
                print("Sent: \(message)")
            }
        }
    }
}
