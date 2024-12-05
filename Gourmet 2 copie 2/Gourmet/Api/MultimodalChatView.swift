//
//  MultimodalChatView.swift
//  Gourmet
//
//  Created by Nawel kaabi on 2/12/2024.
//

import SwiftUI
import PhotosUI

struct MultimodalChatView: View {
    @State private var chatService = ChatService()
    @State private var photoPickerItems = [PhotosPickerItem]()
    @State private var selectedMedia = [Media]()
    @State private var showAttachmentOptions = false
    @State private var showPhotoPicker = false
    @State private var showFilePicker = false
    @State private var loadingMedia = false
    @State private var photosSelected = false

    var body: some View {
        VStack {
            // MARK: Logo
            Image(.logo)
                .resizable()
                .scaledToFit()
                .frame(width: 150)
            
            // MARK: Chat message list
            ScrollViewReader(content: { proxy in
                ScrollView {
                    ForEach(chatService.messages, id: \.self.id) { message in
                        // MARK: Chat message view
                        ChatMessageView(chatMessage: message)
                    }
                }
                .onChange(of: chatService.messages) { _ in
                    scrollToBottom(proxy: proxy)
                }
                .onChange(of: chatService.loadingResponse) { _ in
                    scrollToBottom(proxy: proxy)
                }
            })
            
            // MARK: Image preview
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
            
            // MARK: Attachment Button
            HStack {
                Button {
                    showAttachmentOptions.toggle()
                } label: {
                    if loadingMedia {
                        ProgressView()
                            .tint(Color.white)
                            .frame(width: 40)
                    } else {
                        Image(systemName: "paperclip")
                            .frame(width: 40, height: 25)
                    }
                }
                .disabled(chatService.loadingResponse)
                .confirmationDialog("What would you like to attach?",
                                    isPresented: $showAttachmentOptions,
                                    titleVisibility: .visible) {
                    Button("Images") {
                        showPhotoPicker.toggle()
                    }
                    Button("Documents") {
                        showFilePicker.toggle()
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
                        photosSelected = !photoPickerItems.isEmpty
                        for item in photoPickerItems {
                            do {
                                let (mimeType, data, thumbnail) = try await MediaService().processPhotoPickerItem(for: item)
                                selectedMedia.append(.init(mimeType: mimeType, data: data, thumbnail: thumbnail))
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                        loadingMedia.toggle()
                        if photosSelected {
                            sendDefaultMessage()
                        }
                    }
                }
                .fileImporter(isPresented: $showFilePicker,
                              allowedContentTypes: [.text, .pdf],
                              allowsMultipleSelection: true) { result in
                    selectedMedia.removeAll()
                    loadingMedia.toggle()
                    
                    switch result {
                    case .success(let urls):
                        for url in urls {
                            do {
                                let (mimeType, data, thumbnail) = try MediaService().processDocumentItem(for: url)
                                selectedMedia.append(.init(mimeType: mimeType, data: data, thumbnail: thumbnail))
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    case .failure(let error):
                        print("Failed to import file(s): \(error.localizedDescription)")
                    }
                    
                    loadingMedia.toggle()
                }
                
                // Directly send the default question
                if chatService.loadingResponse {
                    ProgressView()
                        .tint(Color.black)
                        .frame(width: 30)
                } else {
                    Button {
                        Task {
                            if photosSelected {
                                await sendDefaultMessage()
                            } else {
                                await chatService.sendMessage(message: "non", media: [])
                            }
                        }
                    } label: {
                        Image(systemName: "paperplane.fill")
                    }
                    .frame(width: 30)
                }
            }
        }
        .foregroundStyle(.black)
        .padding()
        .background {
            Color.white.ignoresSafeArea()
        }
    }

    private func sendDefaultMessage() {
        Task {
            let chatMedia = selectedMedia
            selectedMedia.removeAll()
            await chatService.sendMessage(message: "Identifier les legumes et les objet dans la photo", media: chatMedia)
        }
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

#Preview {
    MultimodalChatView()
}
