import SwiftUI

struct SignInView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Dégradé en arrière-plan pour un design moderne
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color.pink.opacity(0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    // Image animée avec effet de pulsation
                    Image("design")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .scaleEffect(scale)
                        .onAppear {
                            withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                                scale = 1.1
                            }
                        }
                    
                    Text("Sign In")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.pink)
                    
                    // Champ Email
                    TextField("Email", text: $viewModel.email)
                        .padding()
                        .background(Color.pink.opacity(0.1))
                        .cornerRadius(10)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    // Champ Password
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .background(Color.pink.opacity(0.1))
                        .cornerRadius(10)
                    
                    // Lien Forgot Password
                    HStack {
                        Spacer()
                        NavigationLink("Forgot Password?", destination: VerifyEmailView(verificationType: .resetPassword, email: ""))
                            .font(.footnote)
                            .foregroundColor(.pink)
                    }
                    
                    // Bouton Sign In
                    Button(action: {
                        viewModel.signin()
                    }) {
                        Text("Sign In")
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.pink)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .navigationDestination(isPresented: $viewModel.isLoggedIn) {
                        VerifyEmailView(verificationType: .login, email: viewModel.email)
                    }
                    
                    // NavigationLink vers Sign Up
                    NavigationLink("Don't have an account? Sign Up", destination: SignUpView())
                        .padding(.top, 10)
                        .foregroundColor(Color.black)
                    
                    // Affichage des erreurs
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding()
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
