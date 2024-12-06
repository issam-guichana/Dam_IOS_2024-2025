import SwiftUI

struct VerifyEmailView: View {
    let verificationType: VerificationType
    @State var email: String
    @State private var isShowingAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var navigateToOTP = false
    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        NavigationView {
            VStack {
                // Icône de verrou
                Image(systemName: "lock.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.pink)
                    .padding(.top, 50)

                // Titre principal
                Text("Verifying Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.pink)
                    .padding(.top, 20)

                // Sous-titre
                Text("Don't worry! It happens. Please enter the email address associated with your account.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .padding(.top, 10)

                // Champ de texte pour email
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal, 30)
                    .padding(.top, 20)

                // Bouton d'envoi
                Button(action: {
                    if email.isEmpty {
                        alertMessage = "Email is required."
                        isShowingAlert = true
                    } else if !isValidEmail(email) {
                        alertMessage = "Please enter a valid email address."
                        isShowingAlert = true
                    } else {
                        viewModel.email = email
                        viewModel.verifyEmail()
                        alertMessage = "Verify profile link sent to your email."
                        isShowingAlert = true
                        navigateToOTP = true
                    }
                }) {
                    Text("Send Code Link")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.pink)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)

                Spacer()

                // Navigation vers la vue OTP
                NavigationLink(
                    destination: OTPVerificationView(email: viewModel.email, verificationType: verificationType),
                    isActive: $navigateToOTP
                ) { EmptyView() }
            }
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text("Password Reset"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    // Fonction pour valider le format de l'email
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        VerifyEmailView(verificationType: .login, email: "")
    }
}
