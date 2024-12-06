//
//  ImageAnalyze.swift
//  Gourmet
//
//  Created by Ala Din Habibi on 11/28/24.
//

import SwiftUI
import PhotosUI

struct ImageAnalysisView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var isPickerPresented = false
    @State private var selectedImage: UIImage?

    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            }

            Button("Choisir une image") {
                isPickerPresented = true
            }

            if let image = selectedImage {
                Button("Analyser l'image") {
                    if let imageData = image.jpegData(compressionQuality: 0.8) {
                        viewModel.analyzeImage(imageData: imageData)
                    }
                }
                .padding()
            }

            if !viewModel.imageAnalysisResult.isEmpty {
                Text("Résultat de l'analyse : \(viewModel.imageAnalysisResult)")
            }

            if let errorMessage = viewModel.errorMessage {
                            Text("Erreur: \(errorMessage)")
                                .foregroundColor(.red)
                                .padding()
                        }
        }
        .sheet(isPresented: $isPickerPresented) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
}

// Re-utilisation du picker d'image
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        private let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }

            provider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    self.parent.selectedImage = image as? UIImage
                }
            }
        }
    }
}
struct ImageAnalyse_Previews: PreviewProvider {
    static var previews: some View {
        ImageAnalysisView()
    }
}

