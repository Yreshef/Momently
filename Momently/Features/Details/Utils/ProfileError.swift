//
//  ProfileError.swift
//  Momently
//
//  Created by Yohai on 08/05/2025.
//

import Foundation

enum ProfileError: LocalizedError, Identifiable {
    case saveFailed(String)
    case loadFailed(String)

    var id: String { localizedDescription }

    var errorDescription: String? {
        switch self {
        case .saveFailed: return "We couldn't save your baby's info. Please try again later."
        case .loadFailed: return "We couldn’t load your saved info. You can re-enter it below."
        }
    }
}
