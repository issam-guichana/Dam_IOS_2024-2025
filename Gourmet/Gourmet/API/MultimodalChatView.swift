import SwiftUI
import _PhotosUI_SwiftUI

struct MultimodalChatView: View {
    
    @State private var chatService = ChatService()
    @State private var photoPickerItems = [PhotosPickerItem]()
    @State private var selectedMedia = [Media]()
    @State private var showAttachmentOptions = false
    @State private var showPhotoPicker = false
    @State private var loadingMedia = false
    @State private var showPromptEditor = false
    
    @State private var condition1 = ""
    @State private var condition2 = ""
    @State private var condition3 = ""
    @State private var showAIResponses = false
    @State private var aiResponses = [String]()

    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.pink.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)

            VStack {
                
                // Logo
                Image(.logo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 190)
                
                // Chat Messages
                ScrollViewReader { proxy in
                    ScrollView {
                        ForEach(chatService.messages, id: \.self.id) { message in
                            ChatMessageView(chatMessage: message)
                        }
                    }
                    .onChange(of: chatService.messages) { _ in
                        scrollToBottom(proxy: proxy)
                    }
                    .onChange(of: chatService.loadingResponse) { _ in
                        scrollToBottom(proxy: proxy)
                    }
                }
                
                // Image Preview
                if selectedMedia.count > 0 {
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 10) {
                            ForEach(0..<selectedMedia.count, id: \.self) { index in
                                Image(uiImage: selectedMedia[index].thumbnail)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                            }
                        }
                    }
                    .frame(height: 50)
                    .padding(.bottom, 8)
                }
                
                // Attachment Button
                HStack {
                    Button {
                        showAttachmentOptions.toggle()
                    } label: {
                        if loadingMedia {
                            ProgressView()
                                .tint(Color.white)
                                .frame(width: 40)
                        } else {
                            Image(systemName: "person.crop.square.on.square.angled.fill")
                                .font(.system(size: 50))
                                .frame(width: 60, height: 60)
                        }
                    }
                    .disabled(chatService.loadingResponse)
                    .confirmationDialog("What would you like to attach?",
                                        isPresented: $showAttachmentOptions,
                                        titleVisibility: .visible) {
                        Button("Images") {
                            showPhotoPicker.toggle()
                        }
                    }
                    .photosPicker(isPresented: $showPhotoPicker,
                                  selection: $photoPickerItems,
                                  maxSelectionCount: 2,
                                  matching: .any(of: [.images]))
                    .onChange(of: photoPickerItems) { _ in
                        Task {
                            loadingMedia.toggle()
                            selectedMedia.removeAll()
                            for item in photoPickerItems {
                                do {
                                    let (mimeType, data, thumbnail) = try await MediaService().processPhotoPickerItem(for: item)
                                    selectedMedia.append(.init(mimeType: mimeType, data: data, thumbnail: thumbnail))
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                            loadingMedia.toggle()
                            if !selectedMedia.isEmpty {
                                showPromptEditor.toggle()
                            }
                        }
                    }
                    
                    if chatService.loadingResponse {
                        ProgressView()
                            .tint(Color.black)
                            .frame(width: 30)
                    }
                }
            }
            
            // Popup to add conditions
            .sheet(isPresented: $showPromptEditor) {
                CustomCenterPopupView(condition1: $condition1, condition2: $condition2, condition3: $condition3) {
                    await sendHiddenPromptMessage()
                }
            }
            .foregroundStyle(.black)
            .padding()
        }
    }

    private func sendHiddenPromptMessage() async {
        let defaultPrompt = """
        Préparer un repas
        pour un nombre de personne de 
        Dans une durée de 
        """
        
        let customPrompt = """
        Identifier les légumes et les objets dans la photo avec les conditions suivantes et :
               
        1.  donner et Préparer un repas \(condition1.isEmpty ? "" : condition1)
        
        2. pour un nombre de personne de \(condition2.isEmpty ? "" : condition2)
        3. Dans une durée de \(condition3.isEmpty ? "" : condition3)
        """
        
        let chatMedia = selectedMedia
        selectedMedia.removeAll()
        await chatService.sendMessage(message: customPrompt, media: chatMedia)
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let recentMessage = chatService.messages.last else { return }
        DispatchQueue.main.async {
            withAnimation {
                proxy.scrollTo(recentMessage.id, anchor: .bottom)
            }
        }
    }
}

struct CustomCenterPopupView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var condition1: String
    @Binding var condition2: String
    @Binding var condition3: String
    var onSave: () async -> Void

    var body: some View {
        VStack(spacing: 0) {
            createHeader() // Ajouter l'icône de retour en haut
            createContent()
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 10)
        .padding(24)
    }

    private func createHeader() -> some View {
        HStack {
            Spacer()
            Button(action: {
                presentationMode.wrappedValue.dismiss() // Fermer la popup
            }) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.gray)
            }
        }
        .padding(12)
    }

    private func createContent() -> some View {
        VStack(spacing: 0) {
            createIllustration()
            Spacer().frame(height: max(12, 0))
            createTitle()
            Spacer().frame(height: max(8, 0))
            createDescription()
            Spacer().frame(height: max(32, 0))
            createTextFields()
            Spacer().frame(height: max(12, 0))
            createButton()
        }
        .padding(.top, 12)
        .padding(.bottom, 24)
        .padding(.horizontal, 24)
    }

    private func createIllustration() -> some View {
        VStack {
            // Large condition icon at the top
            Image(systemName: "list.bullet.rectangle")
            
                .resizable()
                .frame(width: 100, height: 100) // Adjust the size as needed for visual impact
                .foregroundColor(.blue) // Set the color that matches your theme
               
            
            // Existing illustration image
            Image("grad-3")
                .resizable()
                .frame(width: 120, height: 120)
        }
       
    }

    private func createTitle() -> some View {
        Text("Ajout des conditions")
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
    }

    private func createDescription() -> some View {
        Text("Please add conditions to assist the AI in analyzing the image.")
            .font(.system(size: 14))
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
    }

    private func createTextFields() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading) {
                Text("Originalite du repas")
                    .font(.headline)
                TextField("Exp: Tunisien", text: $condition1)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            VStack(alignment: .leading) {
                Text("Nombre de personne")
                    .font(.headline)
                TextField("Exp: 2", text: $condition2)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            VStack(alignment: .leading) {
                Text("Duree du preparation")
                    .font(.headline)
                TextField("Exp: 30 Min", text: $condition3)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
        .padding(.vertical)
    }

    private func createButton() -> some View {
        Button(action: {
            Task {
                await onSave()
                presentationMode.wrappedValue.dismiss() // Dismiss the sheet
            }
        }) {
            Text("Generer")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .frame(height: 46)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(8)
        }
    }
}

#Preview {
    MultimodalChatView()
}
