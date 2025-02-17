//
//  EmailValidationRepository.swift
//  LoveAnimals
//
//  Created by Dilara Öztas on 17.02.25.
//

import Foundation

class EmailValidationRepository {
    static let shared = EmailValidationRepository()
    
    private init() {}
    
    func validateEmailWithAPI(email: String) async throws -> Bool {
        let apiKey = "0d8e642fb6553ae725cf74aee3022564"
        let urlString = "https://apilayer.net/api/check?access_key=\(apiKey)&email=\(email)&smtp=1&format=1"

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        
        let isValid = json?["format_valid"] as? Bool ?? false
        let hasMX = json?["mx_found"] as? Bool ?? false
        let isSMTP = json?["smtp_check"] as? Bool ?? false

        return isValid && hasMX && isSMTP
    }

    
}
