import Foundation
import Network
import SwiftUI

final class NetworkMonitor: ObservableObject { // Conform to ObservableObject
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    
    @Published var isConnected: Bool = false // Use @Published for properties to notify changes
    
    init() {
        networkMonitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
}
