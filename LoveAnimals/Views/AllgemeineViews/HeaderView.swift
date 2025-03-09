//
//  HeaderView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 07.03.25.
//

import SwiftUI

struct HeaderView: View {
    let profileImage: UIImage?
    @Binding var searchText: String
    @Binding var showBackgroundOverlay: Bool
    @Binding var showMenu: Bool
    @Binding var menuPosition: CGPoint

    var body: some View {
        HStack {
            Image(uiImage: profileImage ?? UIImage(named: "Kein-Foto")!)
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())

            TextField("Suche...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())

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
    }
}
