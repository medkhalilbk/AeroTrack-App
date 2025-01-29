import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Settings")
                    .font(.largeTitle)
                    .padding(.top)

                // Button to navigate to Change Name page
                NavigationLink(destination: ChangeNameView()) {
                    Text("Change Name")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.purple)
                        .cornerRadius(8)
                }

                // Button to navigate to Change Email page
                NavigationLink(destination: ChangeEmailView()) {
                    Text("Change Email")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.purple)
                        .cornerRadius(8)
                }

                // Button to navigate to Change Password page
                NavigationLink(destination: ChangePasswordView()) {
                    Text("Change Password")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.purple)
                        .cornerRadius(8)
                }

                Spacer() // Push content to the top
            }
            .padding(.horizontal) // Horizontal padding for the entire view
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// Preview for the main settings view
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

struct ChangeNameView: View {
    @State private var fullName: String = ""

    var body: some View {
        VStack {
            Text("Change Name")
                .font(.largeTitle)
                .padding()

            TextField("Enter your full name", text: $fullName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                // Handle name change action here
            }) {
                Text("Update Name")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .cornerRadius(8)
            }
            .padding(.top)

            Spacer()
        }
        .padding()
        .navigationTitle("Change Name")
    }
}


struct ChangeEmailView: View {
    @State private var email: String = ""

    var body: some View {
        VStack {
            Text("Change Email")
                .font(.largeTitle)
                .padding()

            TextField("Enter your new email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                // Handle email change action here
            }) {
                Text("Update Email")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .cornerRadius(8)
            }
            .padding(.top)

            Spacer()
        }
        .padding()
        .navigationTitle("Change Email")
    }
}

struct ChangePasswordView: View {
    @State private var password: String = ""
    @State private var newPassword: String = ""

    var body: some View {
        VStack {
            Text("Change Password")
                .font(.largeTitle)
                .padding()

            SecureField("Current Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("New Password", text: $newPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                // Handle password change action here
            }) {
                Text("Update Password")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .cornerRadius(8)
            }
            .padding(.top)

            Spacer()
        }
        .padding()
        .navigationTitle("Change Password")
    }
}
