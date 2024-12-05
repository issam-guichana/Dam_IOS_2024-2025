import SwiftUI

struct ForgotPasswordView: View {
    @State private var email: String = ""
    @State private var isShowingAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var navigateToOTP = false // State to navigate to OTP screen
    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        NavigationView {
            VStack {
                // Lock icon
                Image(systemName: "lock.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.pink)
                    .padding(.top, 50)

                // Main title
                Text("Forgot Password?")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.pink)
                    .padding(.top, 20)

                // Subtitle
                Text("Don't worry! It happens. Please enter the email address associated with your account.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .padding(.top, 10)

                TextField("Email Address", text: $viewModel.email) // Bind directly to viewModel.email
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal, 30)
                    .padding(.top, 20)

                Button(action: {
                    if viewModel.email.isEmpty {
                        alertMessage = "Please enter your email address."
                        isShowingAlert = true
                    } else {
                        viewModel.ForgotPassword(email: viewModel.email) { success, userId in
                            if success {
                                alertMessage = "Password reset OTP sent to your email."
                                navigateToOTP = true
                                print("User ID: \(userId ?? "No user ID")") // Debugging
                            } else {
                                alertMessage = "Failed to send password reset email."
                            }
                            isShowingAlert = true
                        }
                    }
                }) {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.pink)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)



                Spacer()

                // Navigation to OTP screen
                NavigationLink(
                    destination: OTPVerificationView(email: viewModel.email, userId: viewModel.userId),
                    isActive: $navigateToOTP
                ) { EmptyView() }

            }
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text("Password Reset"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}

