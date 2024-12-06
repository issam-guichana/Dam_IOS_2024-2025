import SwiftUI

struct OTPVerificationView: View {
    var email: String
    let verificationType: VerificationType
    @State private var otpCode: [String] = ["", "", "", "","",""] // Pour champs OTP
    @State private var isShowingAlert: Bool = false
    @State private var alertMessage: String = ""
    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        NavigationView {
            VStack {
                // Barre de navigation avec un bouton retour
                HStack {
                    Button(action: {
                        // Ajouter une action de retour si nécessaire
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.red)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                // Titre principal
                Text("OTP Verification")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.pink)
                    .padding(.top, 10)

                // Image (remplacez "deset" par une ressource valide)
                Image(uiImage: UIImage(named: "deset") ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 150)
                    .cornerRadius(10)
                    .padding(.top, 10)

                // Sous-titre
                Text("Enter OTP Sent to \(email)")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.top, 20)

                // Champs OTP
                HStack(spacing: 10) {
                    ForEach(0..<6) { index in
                        TextField("", text: $otpCode[index])
                            .frame(width: 50, height: 50)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                    }
                }
                .padding(.vertical, 20)

                // Bouton de vérification
                Button(action: {
                    viewModel.OTPCode = otpCode.joined()
                    viewModel.email = email
                    viewModel.verifyOTP()
                }) {
                    Text("Verify OTP")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.pink)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

            
                .padding(.top, 20)

                Spacer()

                // Navigation conditionnelle vers la vue de réinitialisation
                NavigationLink(
                    destination: ResetPasswordView(email: email),
                    isActive: Binding.constant(viewModel.isOTPValid && verificationType == .resetPassword)
                ) { EmptyView() }
            }
            .padding(.vertical, 10)
            .background(Color.white)
            .alert(isPresented: $isShowingAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationBarHidden(true) // Cacher la barre de navigation par défaut
    }
}


struct OTPVerificationView_Previews: PreviewProvider {
static var previews: some View {
OTPVerificationView(email: "example@example.com", verificationType: .login)
}
}

