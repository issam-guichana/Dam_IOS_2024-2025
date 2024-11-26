import SwiftUI

struct SignInView: View {
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        ZStack {
            // Dégradé en arrière-plan
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.brown]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                
                Text("Sign In")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                
                TextField("Email", text: $viewModel.email)
                    .padding()
                    .background(Color.white.opacity(0.2)) // Couleur de fond plus claire
                    .cornerRadius(5)
                
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(5)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage).foregroundColor(.red)
                }
                
                HStack {
                    Spacer()
                    NavigationLink("Forgot Password ?", destination: ForgotPasswordView())
                        .font(.footnote)
                        .foregroundColor(Color.black)
                }
                
                Button("Sign In") {
                    viewModel.signin()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(Color.black)
                .cornerRadius(5)
                
                NavigationLink("Don't have an account? Sign Up", destination: SignUpView())
                    .padding(.top, 10)
                    .foregroundColor(Color.black)
            }
            .padding()
        }
     
    }
}

#Preview {
    SignInView()
}
