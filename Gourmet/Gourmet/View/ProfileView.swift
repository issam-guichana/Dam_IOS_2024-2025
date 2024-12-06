import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var isNavigatingToEditProfile = false // Contrôle de la navigation

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // Bouton "Log Out"
                HStack {
                    Spacer()
                    Button(action: {
                        AuthManager.shared.clearTokens()
                        viewModel.isSignedOutUser = true
                    }) {
                        Text("Log Out")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.red.opacity(0.2))
                            .cornerRadius(20)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)

                Spacer()
                
                // Section d'informations utilisateur
                VStack(spacing: 15) {
                    ProfileInfoCard(icon: "person.fill", label: "Username", value: viewModel.profile?.username ?? "Loading...")
                    ProfileInfoCard(icon: "envelope.fill", label: "Email", value: viewModel.profile?.email ?? "Loading...")
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 5)

                // Bouton "Edit Profile"
                Button(action: {
                    isNavigatingToEditProfile = true
                }) {
                    Text("Edit Profile")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(15)
                        .shadow(color: .pink.opacity(0.5), radius: 5, x: 0, y: 5)
                }
                .padding(.horizontal)

                // Bouton "Delete User"
                Button(action: {
                    viewModel.deleteUser()
                }) {
                    Text("Delete User")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(15)
                        .shadow(color: .red.opacity(0.5), radius: 5, x: 0, y: 5)
                }
                .padding(.horizontal)
                .navigationDestination(isPresented: $viewModel.isSignedOutUser) {
                    SignInView()
                }

                Spacer()
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.pink.opacity(0.1), Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            // Destination pour modifier le profil
            .navigationDestination(isPresented: $isNavigatingToEditProfile) {
                if let profile = viewModel.profile {
                    EditUserView(viewModel: viewModel, profile: profile)
                } else {
                    Text("Error: Profile data not loaded.")
                }
            }
            .onAppear {
                viewModel.fetchProfile()
            }
        }
    }
}

// Vue Helper pour afficher les cartes d'information utilisateur
struct ProfileInfoCard: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.pink)
                .frame(width: 30, height: 30)
                .background(Circle().fill(Color.pink.opacity(0.2)))
            
            VStack(alignment: .leading, spacing: 5) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.headline)
                    .fontWeight(.medium)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
    }
}

#Preview {
    ProfileView()
}
