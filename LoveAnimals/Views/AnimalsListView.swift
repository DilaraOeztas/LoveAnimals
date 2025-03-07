//
//  AnimalsListView.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 06.03.25.
//

//import SwiftUI
//
//struct AnimalsListView: View {
//    @StateObject private var viewModel = AnimalsViewModel()
//    let userCoordinates: (latitude: Double, longitude: Double)?
//
//    var body: some View {
//        ScrollView {
//            LazyVStack {
//                ForEach(viewModel.animals) { animal in
//                    AnimalsView(animal: animal, userCoordinates: userCoordinates)
//                        .padding(.vertical, 8)
//                }
//            }
//            .padding()
//        }
//        .task {
//            await viewModel.ladeAlleTiere()
//        }
//        .navigationTitle("Alle Tiere")
//    }
//}
//
//
//
//
//#Preview {
//    AnimalsListView(userCoordinates: (latitude: 50.1109, longitude: 8.6821))
//        .environmentObject(AnimalsViewModel())
//}
