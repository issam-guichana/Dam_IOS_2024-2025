import SwiftUI

struct ResetPasswordView: View {
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var isShowingAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var navigateToSignIn = false // État pour la navigation vers SignInView

    var body: some View {
        ZStack {
            // Dégradé en arrière-plan
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.brown]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Reset Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                SecureField("New Password", text: $newPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                
                SecureField("Confirm New Password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)

                Button(action: {
                    // Validation de correspondance des mots de passe
                    if newPassword == confirmPassword {
                        alertMessage = "Password has been reset successfully."
                        isShowingAlert = true
                        navigateToSignIn = true // Activer la navigation après la réinitialisation du mot de passe
                    } else {
                        alertMessage = "Passwords do not match. Please try again."
                        isShowingAlert = true
                    }
                }) {
                    Text("Reset Password")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                
                Spacer()

                // Navigation vers SignInView après la réinitialisation réussie du mot de passe
                NavigationLink(
                    destination: SignInView(),
                    isActive: $navigateToSignIn
                ) { EmptyView() }
            }
            .alert(isPresented: $isShowingAlert) {
                Alert(
                    title: Text("Password Reset"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
