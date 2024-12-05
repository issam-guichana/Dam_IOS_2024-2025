import SwiftUI

struct SignupView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var isSignUpSuccessful = false
    @State private var isShowingSuccessAlert = false
    @State private var confirmPassword = ""
    @State private var scale: CGFloat = 1.0
    var body: some View {
        ScrollView { // Allow scrolling if content overflows
            VStack(spacing: 20) {
                
                Image("design")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                                .scaleEffect(scale) // Applique l'effet de scale
                                .onAppear {
                                    withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                                        scale = 1.1 // Scale pour le pulsation
                                    }
                                }

                // Title
                Text("Create an Account")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.pink)
                    .padding(.top, 20)

                // Username Field
                TextField("Username", text: $viewModel.name)
                    .padding()
                    .background(Color.pink.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)

                // Email Field
                TextField("Email", text: $viewModel.email)
                    .padding()
                    .background(Color.pink.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

                // Password Field
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(Color.pink.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)

                // Password Field
                SecureField("Confirm Password", text: $viewModel.confirmPassword)
                    .padding()
                    .background(Color.pink.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                

                // Display Error Message if any
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                // Sign Up Button
                Button(action: {
                    if viewModel.name.isEmpty || viewModel.email.isEmpty || viewModel.password.isEmpty {
                        viewModel.errorMessage = "All fields are required."
                    } else {
                        viewModel.errorMessage = nil
                        viewModel.signUp() // Call the ViewModel's signUp method
                        isShowingSuccessAlert = true
                    }
                }) {
                    Text("Sign Up")
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                // Navigation to Login Page after Successful Sign Up
                NavigationLink(
                    destination: SignInView(),
                    isActive: $isSignUpSuccessful
                ) { EmptyView() }
            }
            .padding()
        }
        .alert(isPresented: $isShowingSuccessAlert) {
            Alert(
                title: Text("Success"),
                message: Text("User added successfully."),
                dismissButton: .default(Text("OK")) {
                    isSignUpSuccessful = true
                }
            )
        }
        .background(Color.white.ignoresSafeArea()) // White background
    }
}
