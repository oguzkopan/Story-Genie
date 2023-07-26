import SwiftUI
import Firebase

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
                .padding()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Login", action: login)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
                .padding()

            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    private func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
            } else {
                // Login successful, do something (e.g., navigate to the main content view)
            }
        }
    }
}

struct LogoutView: View {
    var body: some View {
        VStack {
            Text("You are logged in.")
                .font(.largeTitle)
                .padding()

            Button("Logout", action: logout)
                .padding()
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(8)
                .padding()

            Spacer()
        }
        .padding()
    }

    private func logout() {
        do {
            try Auth.auth().signOut()
            // Logout successful, do something (e.g., navigate to the login view)
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

