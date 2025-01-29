import SwiftUI

struct RegisterView: View {
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var link: String = ""
    @State private var frequency: Double = 0.1
    @State private var loading: Bool = true
    @State private var errorSub: Bool = false
    @State private var errorMessage: String = ""
    @State private var step = -1
    @State private var submitted: Bool = false
    @ObservedObject var networkMonitor = NetworkMonitor() // Use @ObservedObject
    
    struct AccountCreationData: Codable {
        var fullName: String
        var email: String
        var password: String
        var link: String
        var frequency: Double
    }
    func isValidEmail(_ email: String) -> Bool {
        // Regular expression for a valid email address
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }

    func createAccount(completion: @escaping (Result<String, Error>) -> Void) {
        var accountData: AccountCreationData = AccountCreationData(fullName: fullName, email: email, password: password, link: link, frequency: frequency)

        guard let url = URL(string: "http://192.168.1.2:3000/register") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(accountData)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }

        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                DispatchQueue.main.async {
                    completion(.success("Account created successfully"))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "Server error", code: 0, userInfo: nil)))
                }
            }
        }.resume()
    }

    var body: some View {
        VStack {
            if !networkMonitor.isConnected {
                VStack(spacing: 20) {
                    Text("Internet status:")
                        .font(.title)
                    Image(systemName: "wifi.slash")
                        .font(.title)
                        .foregroundColor(.red)
                    Text("No Internet Connection")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    Spacer()
                }
                .padding()
            } else {
                VStack {
                    HStack {
                        Text("Welcome to")
                            .font(.largeTitle)
                            .padding(.top, 5)
                        Text("AeroTrack")
                            .font(.largeTitle)
                            .padding(.top, 5)
                            .foregroundColor(.purple)
                    }
                    
                    if step == -1 {
                        VStack {
                            Text("Empowering Clean Air with Data.")
                                .padding(.top, 1)
                            Image("PhoneIcon")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipped()
                                .padding(.vertical, 40)
                            Text("AeroTrack is dedicated to helping you monitor air quality in real-time and contribute to the global effort to improve environmental health.")
                                .padding(.horizontal, 50)
                            
                            Spacer()

                            Button(action: {
                                step += 1
                            }) {
                                Text("Next")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.purple)
                                    .cornerRadius(8)
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 20)
                        }
                    }
                    
                    // Step 1: Full Name
                    if step == 0 {
                        StepView(
                            title: "Step 1: Enter your full name",
                            placeholder: "Full Name",
                            inputText: $fullName,
                            errorMessage: errorMessage,
                            nextAction: {
                                if !fullName.isEmpty {
                                    step += 1
                                    errorMessage = ""
                                } else {
                                    errorMessage = "Please enter your full name."
                                }
                            }
                        )
                    }

                    // Step 2: Email
                    else if step == 1 {
                        StepView(
                            title: "Step 2: Enter your email address",
                            placeholder: "Email",
                            inputText: $email,
                            errorMessage: errorMessage,
                            nextAction: {
                                if isValidEmail(email) {
                                    step += 1
                                    errorMessage = ""
                                } else {
                                    errorMessage = "Please enter a valid email address."
                                }
                            }
                        )
                    }

                    // Step 3: Password
                    if step == 2 {
                        StepView(
                            title: "Step 3: Create a password",
                            placeholder: "Password",
                            inputText: $password,
                            errorMessage: errorMessage,
                            isSecure: true,
                            nextAction: {
                                if password.count >= 6 {
                                    step += 1
                                    errorMessage = ""
                                } else {
                                    errorMessage = "Password must be at least 6 characters."
                                }
                            }
                        )
                    }

                    // Step 4: Confirm Password
                    else if step == 3 {
                        StepView(
                            title: "Step 4: Confirm your password",
                            placeholder: "Confirm Password",
                            inputText: $confirmPassword,
                            errorMessage: errorMessage,
                            isSecure: true,
                            nextAction: {
                                if password == confirmPassword {
                                    step += 1
                                    errorMessage = ""
                                } else {
                                    errorMessage = "Passwords do not match."
                                }
                            }
                        )
                    }

                    // Step 5: Link and Frequency
                    else if step == 4 {
                        VStack {
                            Text("Step 5: Setup Link and Frequency")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .padding(.top, 20)

                            TextField("IP address / URL", text: $link)
                                .keyboardType(.URL)
                                .autocapitalization(.none)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .padding(.horizontal, 16)

                            Slider(value: $frequency, in: 0...120)
                                .padding(.horizontal, 16)

                            Text(String(format: "%.2f seconds", frequency))
                                .padding(.horizontal, 16)

                            Spacer()

                            Button(action: {
                                step += 1
                                createAccount { result in
                                    switch result {
                                    case .success(let message):
                                        print(message)
                                    case .failure(let error):
                                        errorSub = true
                                        print("Error creating account: \(error.localizedDescription)")
                                    }
                                }
                            }) {
                                Text("Next")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.purple)
                                    .cornerRadius(8)
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 20)
                        }
                    }

                    // Step 6: Confirmation
                    else if step == 5 {
                        ConfirmationView(loading: $loading, errorSub: $errorSub, submitted: $submitted)
                    }
                }
            }
        }
    }
}

struct StepView: View {
    var title: String
    var placeholder: String
    @Binding var inputText: String
    var errorMessage: String
    var isSecure: Bool = false
    var nextAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.top, 20)
                .padding(.horizontal, 16)

            if isSecure {
                SecureField(placeholder, text: $inputText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 16)
            } else {
                TextField(placeholder, text: $inputText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 16)
            }

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.horizontal, 16)
            }

            Spacer()

            Button(action: nextAction) {
                Text("Next")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
    }
}

struct ConfirmationView: View {
    @Binding var loading: Bool
    @Binding var errorSub: Bool
    @Binding var submitted: Bool

    var body: some View {
        VStack {
            if loading {
                ProgressView()
                    .padding(.top, 20)
            } else {
                if errorSub {
                    Text("Something went wrong!")
                        .foregroundColor(.red)
                        .padding()
                } else if submitted {
                    Text("Account successfully created!")
                        .foregroundColor(.green)
                        .padding()
                } else {
                    Text("Create account failed.")
                        .foregroundColor(.red)
                        .padding()
                }
            }
        }
    }
}
