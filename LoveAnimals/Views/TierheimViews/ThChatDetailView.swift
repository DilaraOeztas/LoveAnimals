//
//  ThChatDetailView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 16.03.25.
//

import SwiftUI

struct ThChatDetailView: View {
    let chat: Chat
    @State private var messageText = ""
    @State private var messages: [Message] = [
        Message(id: 1, text: "Hallo, ich interessiere mich für Max, den Labrador.", isUser: true),
        Message(id: 2, text: "Hallo! Max ist noch zu haben. Möchten Sie ihn besuchen?", isUser: false),
        Message(id: 3, text: "Ja, gerne! Wann wäre ein Termin möglich?", isUser: true),
        Message(id: 4, text: "Wie wäre es mit Samstag um 14:00 Uhr?", isUser: false),
        Message(id: 5, text: "Perfekt, das passt. Vielen Dank!", isUser: true)
    ]

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(messages) { message in
                        HStack {
                            if message.isUser {
                                Spacer()
                                Text(message.text)
                                    .padding()
                                    .background(Color.blue.opacity(0.8))
                                    .foregroundStyle(.white)
                                    .cornerRadius(12)
                                    .frame(maxWidth: 250, alignment: .trailing)
                            } else {
                                Text(message.text)
                                    .padding()
                                    .background(Color.gray.opacity(0.3))
                                    .foregroundStyle(.black)
                                    .cornerRadius(12)
                                    .frame(maxWidth: 250, alignment: .leading)
                                Spacer()
                            }
                        }
                    }
                }
                .padding()
            }

            HStack {
                TextField("Nachricht schreiben...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundStyle(.blue)
                        .padding()
                }
            }
            .background(Color(.systemGray6))
        }
        .navigationTitle(chat.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sendMessage() {
        if !messageText.isEmpty {
            messages.append(Message(id: messages.count + 1, text: messageText, isUser: true))
            messageText = ""
        }
    }
}



#Preview {
    ThChatDetailView(chat: Chat(id: 1, name: "Tierheim Berlin", lastMessage: "Gerne können Sie das Tier besuchen!", timestamp: "14:30", isToday: true))
}
