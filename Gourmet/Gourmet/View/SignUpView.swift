import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var isShowingSuccessAlert = false
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ZStack {
                    // Dégradé en arrière-plan
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
                        
                        // Titre
                        Text("Create an Account")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.pink)
                            .padding(.top, 10)
                        
                        // Champ Username
                        TextField("Username", text: $viewModel.username)
                            .padding()
                            .background(Color.pink.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        
                        // Champ Email
                        TextField("Email", text: $viewModel.email)
                            .padding()
                            .background(Color.pink.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        // Champ Password
                        SecureField("Password", text: $viewModel.password)
                            .padding()
                            .background(Color.pink.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        
                       
                        
                        // Message d'erreur
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        
                        // Bouton Sign Up
                        Button(action: {
                            if viewModel.areCredentialsValid() {
                                viewModel.signUp()
                                isShowingSuccessAlert = true
                            } else {
                                viewModel.errorMessage = "All fields are required."
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
                        
                        // Lien de navigation vers la page de connexion
                        NavigationLink("Already have an account? Sign In", destination: SignInView())
                            .padding(.top, 10)
                            .foregroundColor(Color.black)
                    }
                    .padding()
                }
            }
            // Alerte de succès
            .alert(isPresented: $isShowingSuccessAlert) {
                Alert(
                    title: Text("Success"),
                    message: Text("User added successfully."),
                    dismissButton: .default(Text("OK"), action: {
                        viewModel.isSignedUp = true
                    })
                )
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
