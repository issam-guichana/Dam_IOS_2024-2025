import SwiftUI

struct TextInputView: View {
    @State private var condition1: String = ""
    @State private var condition2: String = ""
    @State private var condition3: String = ""
    let initialText: String
    let onSubmit: (String, String, String) -> Void

    var body: some View {
        VStack {
            Text("Texte extrait: \(initialText)")

            TextField("Condition 1", text: $condition1)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Condition 2", text: $condition2)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Condition 3", text: $condition3)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Soumettre") {
                onSubmit(condition1, condition2, condition3)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}

#Preview {
    TextInputView(initialText: "Exemple", onSubmit: { _, _, _ in })
}
