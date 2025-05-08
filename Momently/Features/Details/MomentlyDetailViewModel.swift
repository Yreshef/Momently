//
//  MomentlyDetailViewModel.swift
//  Momently
//
//  Created by Yohai on 07/05/2025.
//

import SwiftUI
import Combine

final class MomentlyDetailViewModel: ObservableObject {
    
    @Published var babyName: String = ""
    @Published var birthday: Date? = nil
    @Published var selectedImage: UIImage? = nil
    
    var isFormValid: Bool {
        !babyName.trimmingCharacters(in: .whitespaces).isEmpty && birthday != nil
    }
    
    func handlePhotoTapped() {
        //TODO: Implement photo picker
    }
    
    func showBirthdayScreen() {
        //TODO: Implement navigation
    }
}
