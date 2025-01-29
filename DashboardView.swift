import SwiftUI

struct DashboardView: View {
    @State private var isLoading = true
    @State private var showModal = false
    @State private var showToast = false
    @State private var simulating = false
    @State private var isConencted = false
    @State private var isOn = true
    @ObservedObject var mqttManager = MQTTManager() // Observe MQTTManager

    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    if isLoading {
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                            .scaleEffect(1.5)
                            .padding(.top, 50)
                    } else {
                        HStack {
                            Text(mqttManager.data != "" ? "Current PPM: " : "")
                                .fontWeight(.bold)
                                .font(.title2)
                            Text("\(mqttManager.data)")
                                .fontWeight(.bold)
                                .font(.title2)
                                .foregroundColor(.purple)
                        }
                        
                        ChartView()
                        
                        VStack {
                            let color = isOn ? Color.green : Color.red
                            Toggle(isOn: $isOn) {
                                Text("Listening real time").font(.title3)
                            }
                            .padding()
                            .disabled(true)
                            .foregroundColor(color)

                            Text(isOn ? "Connected" : "Not Connected")
                                .foregroundColor(.purple)
                        }

                        Button(action: {
                            // Use MQTTManager to manage connection
                            if mqttManager.isConnected {
                                mqttManager.disconnect()
                            } else {
                                mqttManager.connect()
                            }
                            isOn.toggle()
                        }) {
                            Text(mqttManager.isConnected ? "Disconnect" : "Connect")
                                .font(.title)
                                .padding()
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.bottom, 20) // Add padding to the bottom of the button
                        
                        // Display Toast if simulation starts
                        if showToast {
                            Text("Simulation started!")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .transition(.move(edge: .bottom))
                                .animation(.easeInOut)
                                .padding(.bottom, 40)
                        }
                    }
                    Spacer()
                }
                .padding()
                .onAppear(perform: loadData)
            }
            .tabItem {
                Label("Dashboard", systemImage: "house").foregroundColor(.purple)
            }
            
            // Add more tabs here
            Text("Settings View")
                .tabItem {
                    Label("Settings", systemImage: "gear").foregroundColor(.purple)
                }
        }
        .accentColor(.purple) // Change active tab color to purple
    }

    private func loadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
        }
    }

    private func startActivation() {
        // Your existing API call logic
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
	
