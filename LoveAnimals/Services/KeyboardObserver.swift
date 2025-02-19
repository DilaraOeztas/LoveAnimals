//
//  KeyboardObserver.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 13.02.25.
//

//import SwiftUI
//import Combine
//
//class KeyboardObserver: ObservableObject {
//    @Published var isKeyboardVisible: Bool = false
//    private var cancellables: Set<AnyCancellable> = []
//
//    init() {
//        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
//            .sink { [weak self] _ in
//                DispatchQueue.main.async {
//                    self?.isKeyboardVisible = true
//                }
//            }
//            .store(in: &cancellables)
//
//        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
//            .sink { [weak self] _ in
//                DispatchQueue.main.async {
//                    self?.isKeyboardVisible = false
//                }
//            }
//            .store(in: &cancellables)
//    }
//}
