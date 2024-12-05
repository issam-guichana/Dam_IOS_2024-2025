//
//  ImageAnalyze.swift
//  Gourmet
//
//  Created by Nawel kaabi on 2/12/2024.
//
import SwiftUI
import GoogleGenerativeAI

struct ImageAnalyzeTests: View {
    @State private var analyzedResult: String?
    @State private var isAnalyzing: Bool = false
    @State private var selectedImage: Image? // Replace this with your image source logic.

    let model = GenerativeModel(name: "gemini-pro-vision", apiKey: APIKey.default)

    var body: some View {
        VStack {
            if let selectedImage = selectedImage {
                selectedImage
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
            } else {
                Text("Select an image to analyze")
                    .foregroundColor(.gray)
                    .padding()
            }

            ScrollView {
                Text(analyzedResult ?? (isAnalyzing ? "Analyzing..." : "Result will appear here"))
                    .font(.system(.title2, design: .rounded))
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 20.0))
            .overlay {
                if isAnalyzing {
                    RoundedRectangle(cornerRadius: 20.0)
                        .fill(.black)
                        .opacity(0.5)
                    ProgressView()
                        .tint(.white)
                }
            }

            Button(action: {
                // Replace with your logic to select or update the image.
                // For example, you can use PhotosPicker to set selectedImage.
                analyzeImage()
            }) {
                Text("Analyze Image")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .clipShape(Capsule())
            }
            .padding()
        }
        .padding()
    }

    func analyzeImage() {
        guard let selectedImage = selectedImage else { return }

        let imageRenderer = ImageRenderer(content: selectedImage)
        imageRenderer.scale = 1.0

        guard let uiImage = imageRenderer.uiImage else {
            print("Failed to convert SwiftUI image to UIImage")
            return
        }

        let prompt = "Describe the image and explain what objects are found in it."
        isAnalyzing = true

        Task {
            do {
                let response = try await model.generateContent(prompt, uiImage)
                if let text = response.text {
                    DispatchQueue.main.async {
                        analyzedResult = text
                        isAnalyzing = false
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    analyzedResult = "Error: \(error.localizedDescription)"
                    isAnalyzing = false
                }
            }
        }
    }
}

