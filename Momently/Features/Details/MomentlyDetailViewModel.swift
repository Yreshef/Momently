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
    @Published var currentSource: ImageSource = .photoLibrary
    
    private let permissionsService: PhotoPermissionChecking
    
    init(permissionsService: PhotoPermissionChecking) {
        self.permissionsService = permissionsService
    }
    
    var isFormValid: Bool {
        !babyName.trimmingCharacters(in: .whitespaces).isEmpty && birthday != nil
    }
    
    @MainActor
    func handleImagePicked(_ image: UIImage?) {
        selectedImage = image
    }
    
    @MainActor
    func prepareImagePicker(for source: ImageSource) async throws {
        try await permissionsService.checkPermission(for: source)
        currentSource = source
    }
    
    func showBirthdayScreen() {
        //TODO: Implement navigation
    }
}
