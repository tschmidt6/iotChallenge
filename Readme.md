# iot Mower & Generator Control

This iOS app allows users to **remotely monitor and control smart devices** such as lawnmowers and generators over Wi-Fi. It communicates with a local or cloud-based Python FastAPI WebSocket server and receives **real-time alerts**, **battery/fuel status**, and **device runtime information**.

---

## Features

- **Connect to and control devices**
  - Turn devices on/off
  - Toggle lights
- **Live monitoring**
  - Battery and fuel levels
  - Runtime left
  - Load information
- **Real-time alerts**
  - Get notified of low battery, faults, or critical warnings
- **WebSocket communication**
  - Uses `URLSessionWebSocketTask` to maintain a persistent connection to the backend server
- **View device manual PDFs**

---

## Screenshots

<img src="https://github.com/tschmidt6/iotChallenge/blob/main/screenshots/dashboard.png" width=50% height=50%>

<img src="https://github.com/tschmidt6/iotChallenge/blob/main/screenshots/devices.png" width=50% height=50%>

<img src="https://github.com/tschmidt6/iotChallenge/blob/main/screenshots/alerts.png" width=50% height=50%>

<img src="https://github.com/tschmidt6/iotChallenge/blob/main/screenshots/settings.png" width=50% height=50%>

<img src="https://github.com/tschmidt6/iotChallenge/blob/main/screenshots/manualView.png" width=50% height=50%>

<img src="https://github.com/tschmidt6/iotChallenge/blob/main/screenshots/lawnmowerDetail.png" width=50% height=50%>

<img src="https://github.com/tschmidt6/iotChallenge/blob/main/screenshots/generatorDetail.png" width=50% height=50%>

<img src="https://github.com/tschmidt6/iotChallenge/blob/main/screenshots/backupGeneratorDetail.png" width=50% height=50%>

---

## Architecture

- **SwiftUI** frontend with MVVM architecture
- **FastAPI** WebSocket server backend
- Real-time JSON messaging with support for multiple devices via unique UUIDs

### Sample WebSocket JSON Message
```json
{
  "uuid": "123e4567-e89b-12d3-a456-426614174000",
  "device": "lawnmower",
  "battery": 62,
  "status": "Running",
  "runtimeLeft": "34 mins",
  "isLightOn": true,
  "alert": "Battery low"
}
```
## How Alerts Work

- Device (mower, generator) sends JSON message to the server
- Server broadcasts the message via WebSocket
- App listens and decodes the message
- Alerts are updated on screen, and critical messages can trigger local notifications

### Request to shutdown the generator by clicking the toggle in the app: 
``` 
Received: {"command": "shutdown", "device": "generator"}  
```

### Request to turn on the light by clicking the toggle in the app:  
```
💡 generator light turned ON
```

<img src="https://github.com/tschmidt6/iotChallenge/blob/main/simulator.gif" width=50% height=50%>

<img src="https://github.com/tschmidt6/iotChallenge/blob/main/server.gif" width=50% height=50%>