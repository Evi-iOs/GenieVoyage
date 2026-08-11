//
//  PersonalInfoViewModel.swift
//  GenieVoyage
//
//  Created by Evgeniya  Iv on 02.08.2026.
//

import Foundation

final class PersonalInfoViewModel {
    
    private(set) var name: String
    private(set) var email: String
    
    init() {
        self.name = UserDefaults.standard.string(forKey: "profile.userName") ?? "Traveler"
        self.email = UserDefaults.standard.string(forKey: "profile.userEmail") ?? ""
    }
    
    enum SaveError: Error { case emptyName, invalidEmail }
    
    @discardableResult
    func save(name: String, email: String) -> Result<Void, SaveError> {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else { return .failure(.emptyName) }
        guard trimmedEmail.isEmpty || Self.isValidEmail(trimmedEmail) else { return .failure(.invalidEmail) }
        
        UserDefaults.standard.set(trimmedName, forKey: "profile.userName")
        UserDefaults.standard.set(trimmedEmail, forKey: "profile.userEmail")
        self.name = trimmedName
        self.email = trimmedEmail
        return .success(())
    }
    
    private static func isValidEmail(_ email: String) -> Bool {
        let regex = #"^[^\s@]+@[^\s@]+\.[^\s@]+$"#
        return email.range(of: regex, options: .regularExpression) != nil
    }
}
