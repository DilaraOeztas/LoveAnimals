//
//  ThChatsView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 16.03.25.
//

import SwiftUI

struct ThChatsView: View {
    let chats: [Chat] = [
        Chat(id: 1, name: "Max Mustermann", lastMessage: "Gerne können Sie das Tier besuchen!", timestamp: "14:30", isToday: true),
        Chat(id: 2, name: "Dilara Öztas", lastMessage: "Hallo, wir haben noch weitere Hunde zur Vermittlung.", timestamp: "09:45", isToday: true),
        Chat(id: 3, name: "Thomas Müller", lastMessage: "Ja, wir senden Ihnen die Unterlagen per E-Mail zu.", timestamp: "15.03.2024", isToday: false),
        Chat(id: 4, name: "Jannes Schäfer", lastMessage: "Der Kater ist noch zu haben!", timestamp: "12.03.2024", isToday: false),
        Chat(id: 5, name: "Carola Schmitt", lastMessage: "Wir haben aktuell viele Kaninchen zur Adoption.", timestamp: "10.03.2024", isToday: false)
    ]
    
    var body: some View {
        NavigationStack {
            List(chats) { chat in
                NavigationLink(destination: ThChatDetailView(chat: chat)) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundStyle(.gray)

                        VStack(alignment: .leading) {
                            Text(chat.name)
                                .font(.headline)
                            Text(chat.lastMessage)
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .lineLimit(1)
                        }
                        Spacer()
                        Text(chat.timestamp)
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                    .padding(.vertical, 5)
                }
            }
            .navigationTitle("Chats")
        }
    }
}



#Preview {
    ThChatsView()
}
