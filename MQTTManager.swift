import Foundation
import CocoaMQTT

class MQTTManager: NSObject, CocoaMQTTDelegate, ObservableObject  {
    
    var mqttClient: CocoaMQTT?
    @Published var isConnected: Bool = false
    @Published var data: String = "" // Use @Published here, no need for @State
    override init() {
        super.init()
        setupMQTT()
    }

    // Setup MQTT client
    func setupMQTT() {
        let clientID = "CocoaMQTT-" + String(ProcessInfo.processInfo.processIdentifier)
        mqttClient = CocoaMQTT(clientID: clientID, host: "broker.hivemq.com", port: 1883)
        
        mqttClient?.delegate = self
        mqttClient?.connect()
    }

    // Subscribe to a topic
    func subscribeToTopic() {
        let topic = "khalil-53808864/co2"
        mqttClient?.subscribe(topic)
    }

    // Unsubscribe from a topic
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
        print("Unsubscribed from topics: \(topics)")
    }

    // CocoaMQTT delegate methods
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        if ack == .accept {
            print("MQTT connected")
            isConnected = true
            subscribeToTopic() // Subscribe after connection
        }
    }

    // Method for handling published messages
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("Message with ID \(id) was published: \(message.string ?? "")")
    }

    // Method for handling received messages
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        // Update data with the received message
        DispatchQueue.main.async {
            self.data = message.string ?? "" // Ensure UI update happens on the main thread
        }
        print("Received message with ID \(id): \(message.string ?? "") from topic: \(message.topic)")
    }

    // Additional methods required by CocoaMQTTDelegate
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("Message with ID \(id) was acknowledged")
    }

    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        print("Successfully subscribed to topics: \(success)")
        if !failed.isEmpty {
            print("Failed to subscribe to topics: \(failed)")
        }
    }

    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("Ping sent to MQTT broker")
    }

    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        print("Received Pong from MQTT broker")
    }

    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        if let error = err {
            print("Disconnected with error: \(error.localizedDescription)")
        } else {
            print("Disconnected successfully")
        }
    }

    func mqtt(_ mqtt: CocoaMQTT, didDisconnectWithError error: Error?) {
        print("Disconnected with error: \(error?.localizedDescription ?? "none")")
    }

    func disconnect() {
        mqttClient?.disconnect()
    }

    func connect() {
        mqttClient?.connect()
    }
}
