import SwiftUI

struct ResetPasswordView: View {
    var email: String // Utilisation de l'email comme dans le code 1
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var isShowingAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var navigateToSignIn = false // État pour la navigation vers SignInView
    @StateObject private var viewModel = AuthViewModel() // Modèle pour gérer les actions

    var body: some View {
        NavigationView {
            ZStack {
                // Dégradé en arrière-plan
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color.brown]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer()
                    
                    // Icône de verrou (provenant du design 2)
                    Image(systemName: "lock.rotation")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.pink)
                        .padding(.bottom, 20)

                    // Titre (provenant du design 2)
                    Text("Reset Password")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.pink)
                        .padding(.bottom, 20)

                    // Champ pour le nouveau mot de passe
                    SecureField("New password", text: $newPassword)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)

                    // Champ pour confirmer le mot de passe
                    SecureField("Confirm new password", text: $confirmPassword)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)

                    // Bouton pour réinitialiser le mot de passe
                    Button(action: {
                        resetPassword() // Action de réinitialisation
                    }) {
                        Text("Reset Password")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.pink)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // Navigation conditionnelle vers la vue de connexion après la réinitialisation
                    NavigationLink(
                        destination: SignInView(),
                        isActive: $navigateToSignIn
                    ) { EmptyView() }
                }
                .background(Color.white.opacity(0.9)) // Léger fond blanc
                .alert(isPresented: $isShowingAlert) {
                    Alert(
                        title: Text("Password Reset"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
            .navigationBarHidden(true) // Masquer la barre de navigation
        }
    }
    
    // Fonction de validation et réinitialisation locale (basée sur le code 1)
    func resetPassword() {
        // Vérifier si les mots de passe correspondent
        guard newPassword == confirmPassword else {
            alertMessage = "Passwords do not match. Please try again."
            isShowingAlert = true
            return
        }
        
        // Vérifier la longueur minimale du mot de passe
        guard newPassword.count >= 6 else {
            alertMessage = "Password must be at least 6 characters long."
            isShowingAlert = true
            return
        }
        
        // Mettre à jour le modèle de vue pour réinitialiser
        viewModel.newPassword = newPassword
        viewModel.email = email
        viewModel.resetPassword()

        // Simuler une réponse réussie (par exemple)
        alertMessage = "Password has been reset successfully."
        isShowingAlert = true
        navigateToSignIn = true
    }
}
struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView(email: "")
    }
}
