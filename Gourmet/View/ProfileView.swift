import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var isEditingUser = false // Utilisé pour déclencher la navigation vers EditUserView
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Dégradé en arrière-plan
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color.brown]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all) // Remplit tout l'arrière-plan
                
                VStack {
                    Text("Profile")
                        .font(.largeTitle)
                        .padding(.bottom, 20)
                    
                    Text("Username: \(viewModel.username)")
                        .padding(.bottom, 5)
                    Text("Email: \(viewModel.email)")
                        .padding(.bottom, 20)
                    
                    // Bouton de navigation pour "Modifier l'utilisateur"
                    Button("Modify User") {
                        isEditingUser = true
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)

                    Button("Delete User") {
                        // Logique de suppression de l'utilisateur
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    
                    Button("Sign Out") {
                        // Logique de déconnexion
                    }
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                }
                .padding()
                .navigationDestination(isPresented: $isEditingUser) {
                    EditUserView()
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
