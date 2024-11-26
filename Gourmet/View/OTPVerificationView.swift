import SwiftUI

struct OTPVerificationView: View {
    var email: String
    @State private var otpCode: String = ""
    @State private var isOTPValid: Bool = false
    @State private var isShowingAlert: Bool = false
    @State private var navigateToResetPassword = false // État pour la navigation vers ResetPasswordView

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
                Text("OTP Verification")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                Text("Enter the OTP sent to \(email)")
                    .font(.subheadline)
                    .padding(.bottom, 10)

                TextField("OTP Code", text: $otpCode)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                
                Button(action: {
                    // Simulation de vérification du code OTP
                    if otpCode == "123456" { // Exemple de code OTP
                        isOTPValid = true
                        navigateToResetPassword = true // Activer la navigation si OTP est valide
                    } else {
                        isShowingAlert = true // Montrer l'alerte si OTP est invalide
                    }
                }) {
                    Text("Verify OTP")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)

                Spacer()

                // Navigation vers ResetPasswordView si OTP est validé
                NavigationLink(
                    destination: ResetPasswordView(),
                    isActive: $navigateToResetPassword
                ) { EmptyView() }
            }
            .alert(isPresented: $isShowingAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text("Invalid OTP. Please try again."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

struct OTPVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        OTPVerificationView(email: "example@example.com")
    }
}
