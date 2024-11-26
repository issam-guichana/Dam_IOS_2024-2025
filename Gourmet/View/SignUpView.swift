import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var isSignUpSuccessful = false
    @State private var isShowingSuccessAlert = false // État pour afficher l'alerte de succès

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
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                
                Text("Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                
                TextField("Username", text: $viewModel.username)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                
                TextField("Email", text: $viewModel.email)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage).foregroundColor(.red)
                }
                
                Button("Save") {
                    if viewModel.areCredentialsValid() {
                        viewModel.signUp()
                        isShowingSuccessAlert = true // Affiche l'alerte de succès
                    } else {
                        viewModel.errorMessage = "Please fill out all fields correctly."
                    }
                }
                
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(Color.black)
                .cornerRadius(5)
                // Navigation vers SignInView si inscription réussie
                NavigationLink(
                    destination: SignInView(),
                    isActive: $isSignUpSuccessful
                ) { EmptyView() }
            }
            .padding()
           
            .cornerRadius(10)
            .padding()
        }
        .navigationTitle("Sign Up")
        
        // Alerte de succès
        .alert(isPresented: $isShowingSuccessAlert) {
            Alert(
                title: Text("Success"),
                message: Text("User added successfully."),
                dismissButton: .default(Text("OK")) {
                    isSignUpSuccessful = true // Naviguer vers SignInView après la fermeture de l'alerte
                }
            )
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
