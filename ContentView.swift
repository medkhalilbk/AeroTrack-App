import SwiftUI
import LocalAuthentication
import CocoaMQTT
struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isUnlocked = false
    @State private var isLogged = false
    
    @State private var navigateToRegister = false
    func loadDefaultData() {
          username = UserDefaults.standard.string(forKey: "username") ?? ""
          password = UserDefaults.standard.string(forKey: "password") ?? ""
      }
    var body: some View {
        NavigationView {
            if isLogged {
                DashboardView() // Navigate to DashboardView when unlocked
            } else {
                VStack {
                    // Image at the top
                    Image("Home")
                        .resizable()
                        .scaledToFit()
                        .scaledToFit()
                        .foregroundColor(Color.purple)
                        .frame(width: 150, height: 150)
                        .padding(.top, 40)
                         

                    // Username input field
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal, 16)

                    // Password input field
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal, 16)
                    
                    Spacer() // Pushes the buttons to the bottom

                    // Login button
                    Button(action: {
                        // Handle login action if biometrics are not available
                        loginfunction()
                    }) {
                        Text("Login")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.purple)
                            .cornerRadius(8)
                            .padding(.horizontal, 16)
                    }

                    // Register button with navigation link to RegisterView
                    NavigationLink(destination: RegisterView(), isActive: $navigateToRegister) {
                        Button(action: {
                            navigateToRegister = true
                        }) {
                            Text("Register")
                                .foregroundColor(.purple)
                        }
                    }
                    .padding(.bottom, 20)
                }.onAppear(perform: authenticate)
               
            }
        }
    }

    // Function to handle biometric authentication
    func authenticate() {
        
        let context = LAContext()
        var error: NSError?

        // Check if biometric authentication is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        // Unlock the view if authentication succeeds
                        self.isUnlocked = true
                        
                        loadDefaultData()
                    } else {
                        // Handle the error if authentication fails
                        print(authenticationError?.localizedDescription ?? "Failed to authenticate")
                    }
                }
            }
        } else {
            print("Biometrics not available")
        }
    }
    func loginfunction(){
        guard let url = URL(string: "http://192.168.1.2:3000/login") else {
            print("Invalid URL")
            return
        }

        // Create a URLRequest object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Prepare the request body with login credentials
        let requestBody: [String: Any] = [
            "username": username,  // Use the correct field name
            "password": password // Use the correct password
        ]

        // Convert dictionary to JSON data
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            print("Error converting request body to JSON: \(error)")
            return
        }

        // Create a URLSession data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle error
            if let error = error {
                print("Request error: \(error.localizedDescription)")
                return
            }
            
            // Check for a valid HTTP response
            if let httpResponse = response as? HTTPURLResponse {
                if(httpResponse.statusCode == 200){
                    UserDefaults.standard.set(username, forKey: "username")
                    UserDefaults.standard.set(password, forKey: "password")
                    self.isLogged = true
                }else{
                    
                }
                
                // Check if there's data returned
                if let data = data {
                    // Try to read the response as text
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Response: \(responseString)")
                    } else {
                        print("Error converting data to string")
                    }
                }
            }
        }

        // Start the request
        task.resume()
    }
}

// Dashboard view with progress indicator


// Registration view


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
