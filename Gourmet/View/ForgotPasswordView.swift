import SwiftUI

struct ForgotPasswordView: View {
    @State private var email: String = ""
    @State private var isShowingAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var navigateToOTP = false // État pour la navigation vers l'OTP
    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        ZStack {
            // Dégradé en arrière-plan
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.brown]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all) // Remplit tout l'arrière-plan
            
            VStack {
                // Header
                Text("Forgot Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)

                // Email Field
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)

                // Bouton pour envoyer le lien de réinitialisation et naviguer vers l'OTP
                Button(action: {
                    viewModel.ForgotPassword()
                    self.isShowingAlert = true
                    self.alertMessage = "Password reset link sent to your email."
                    self.navigateToOTP = true // Définir l'état pour naviguer
                }) {
                    Text("Send Password Reset Link")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)

                Spacer()

                // Navigation vers OTPVerificationView
                NavigationLink(
                    destination: OTPVerificationView(email: viewModel.email),
                    isActive: $navigateToOTP
                ) { EmptyView() }
            }
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text("Password Reset"), message: Text(self.alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
