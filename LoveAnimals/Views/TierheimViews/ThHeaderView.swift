//
//  ThHeaderView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 18.03.25.
//

import SwiftUI
import FirebaseAuth

struct ThHeaderView: View {
    @ObservedObject var tierheimAuthViewModel: TierheimAuthViewModel
    @Binding var searchText: String
    @Binding var showBackgroundOverlay: Bool
    @Binding var showMenu: Bool
    @Binding var menuPosition: CGPoint

    var body: some View {
        HStack {
            if let user = tierheimAuthViewModel.tierheim {
                if let profileImageUrl = user.profileImageUrl {
                    AsyncImage(url: URL(string: profileImageUrl)) { image in
                        image.resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .foregroundStyle(.gray)
                }
            }
            
            TextField("Suche...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundStyle(.primary)

            Button(action: {
                withAnimation {
                    showMenu.toggle()
                    showBackgroundOverlay = showMenu
                }
            }) {
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))
                    .font(.title2)
                    .foregroundStyle(.primary)
            }
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            menuPosition = geo.frame(in: .global).origin
                        }
                        .onChange(of: showMenu) { _, _ in
                            menuPosition = geo.frame(in: .global).origin
                        }
                        
                }
            )
        }
        .padding()
        .onAppear {
            Task {
                await tierheimAuthViewModel.fetchTierheim(userId: Auth.auth().currentUser?.uid ?? "")
            }
        }
    }
}
