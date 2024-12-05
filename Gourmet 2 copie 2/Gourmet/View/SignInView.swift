import SwiftUI

struct SignInView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var islog = false
    @State private var scale: CGFloat = 1.0
    var body: some View {
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

            // Forgot Password Link
            HStack {
                Spacer()
                NavigationLink(destination: ForgotPasswordView()) {
                    Text("Forgot Password?")
                        .font(.footnote)
                        .foregroundColor(Color.pink)
                }
            }
            .padding(.horizontal)

            // Login Button
            Button(action: {
                viewModel.signin { success in
                    if success {
                        islog = true
                    }
                }
            }) {
                Text("Login")
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.pink)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)


            // NavigationLink vers MainTabView
            NavigationLink(
                destination:   HomeView(),
                isActive: $islog
            ) {
                EmptyView() // Vue vide pour déclencher la navigation
            }

            // Display Error Message if any
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            NavigationLink("Don't have an account? Sign Up", destination: SignupView())
                .padding(.top, 10)
                .foregroundColor(Color.black)
        }
        .padding()
    }
}
