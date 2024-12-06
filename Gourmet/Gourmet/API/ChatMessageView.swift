import SwiftUI

struct ChatMessageView: View {
    private let mediaHeight = 150.0
    let chatMessage: ChatMessage
    
    // Variable pour décider si le message texte doit être affiché
    private var shouldHideMessage: Bool {
        return chatMessage.role == .user || (chatMessage.role == .aiModel && chatMessage.message.starts(with: "Identifier"))
    }

    var body: some View {
        VStack {
            // MARK: Chat media - Images envoyées par l'utilisateur à droite
            if let media = chatMessage.media, !media.isEmpty, chatMessage.role == .user {
                GeometryReader { geometry in
                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {
                            Spacer()
                                .frame(width: spacerWidth(for: media, geometry: geometry))
                            
                            ForEach(0..<media.count, id: \.self) { index in
                                let mediaItem = media[index]
                                Image(uiImage: mediaItem.thumbnail)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: mediaHeight)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .overlay(alignment: .topLeading) {
                                        Image(systemName: mediaItem.overlayIconName)
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .shadow(color: .black, radius: 10)
                                            .padding(8)
                                    }
                            }
                        }
                    }
                }
                .frame(height: mediaHeight)
                .frame(maxWidth: .infinity, alignment: .trailing) // Aligner à droite
            }
            
            // MARK: Chat bubble - Texte de l'IA à gauche
            if chatMessage.role == .aiModel && !shouldHideMessage {
                ChatBubble(direction: .left) {
                    Text(chatMessage.message)
                        .font(.title3)
                        .padding(.all, 20)
                        .foregroundStyle(.white)
                        .background(Color.pink)
                }
                .frame(maxWidth: .infinity, alignment: .leading) // Aligner à gauche
            }
        }
        .id(chatMessage.id)
    }
    
    private func spacerWidth(for media: [Media], geometry: GeometryProxy) -> CGFloat {
        var totalWidth: CGFloat = 0
        for mediaItem in media {
            let scaledWidth = mediaItem.thumbnail.size.width * (mediaHeight / mediaItem.thumbnail.size.height)
            totalWidth += scaledWidth + 20
        }
        return totalWidth < geometry.size.width ? geometry.size.width - totalWidth : 0
    }
}

#Preview {
    ChatMessageView(chatMessage: .init(role: .user, message: "", media: nil))
}
