import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = "John Doe"
    @State private var email: String = "johndoe@example.com"
    @State private var password: String = ""
    @State private var avatar: Image? = Image("profile") // Default profile image
    @State private var isPickerPresented: Bool = false
    
    var body: some View {
        ZStack {
            Color("1a1b35")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Edit Profile Header
                    VStack(spacing: 16) {
                        avatar?
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.pink, lineWidth: 2)
                            )
                            .padding(.top)
                        
                        Button(action: {
                            isPickerPresented = true
                        }) {
                            Text("Change Profile Picture")
                                .font(.caption)
                                .foregroundColor(.pink)
                        }
                        .sheet(isPresented: $isPickerPresented) {
                            ImagePicker(image: $avatar)
                        }
                    }

                    // Editable Fields
                    Group {
                        EditField(label: "Name", text: $name)
                        EditField(label: "Email", text: $email)
                        
                    }

                    // Save Changes Button
                    Button(action: {
                        // Add save logic here to send data to backend
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle")
                            Text("Save Changes")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pink)
                        .cornerRadius(12)
                    }
                }
                .padding()
            }

            // Back Button
            VStack {
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding()
        }
        .navigationBarHidden(true)
    }
}

// Image Picker View
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: Image?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
            
            provider.loadObject(ofClass: UIImage.self) { (image, _) in
                if let uiImage = image as? UIImage {
                    DispatchQueue.main.async {
                        self.parent.image = Image(uiImage: uiImage)
                    }
                }
            }
        }
    }
}

struct EditField: View {
    let label: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
            TextField("", text: $text)
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(12)
                .foregroundColor(.white)
        }
    }
}

struct SecureEditField: View {
    let label: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
            SecureField("", text: $text)
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(12)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    EditProfileView()
}
