import SwiftUI

struct ProfileView: View {
    var username: String = "nkaabi"
    var email: String = "nawel.kaabi@example.com"
    @State private var isNavigatingToEditProfile = false // Contrôle de la navigation
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // Log Out Button
                HStack {
                    Spacer()
                    Button(action: {
                        // Log Out Action
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
                
                // Profile Information Section
                VStack(spacing: 15) {
                    ProfileInfoCard(icon: "person.fill", label: "Username", value: username)
                    ProfileInfoCard(icon: "envelope.fill", label: "Email", value: email)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 5)

                // Edit Profile Button
                Button(action: {
                    isNavigatingToEditProfile = true // Active la navigation
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

                Spacer()
            }
            .padding()
            .background(
                Color.pink.opacity(0.1)
                    .ignoresSafeArea()
            )
            // Destination de la navigation
            .navigationDestination(isPresented: $isNavigatingToEditProfile) {
                EditProfileView()
            }
        }
    }
}

// Helper View for Profile Info Cards
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
