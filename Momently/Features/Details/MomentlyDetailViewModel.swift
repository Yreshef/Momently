//
//  MomentlyDetailViewModel.swift
//  Momently
//
//  Created by Yohai on 07/05/2025.
//

import Combine
import SwiftUI

final class MomentlyDetailViewModel: ObservableObject {

    // MARK: Published Properties

    @Published var babyName: String = ""
    @Published var birthday: Date? = nil
    @Published var selectedImage: UIImage? = nil
    @Published var currentSource: ImageSource = .photoLibrary
    
    @Published var profileError: ProfileError?

    // MARK: Dependencies

    private let permissionsService: PhotoPermissionChecking
    private let store: BabyProfileStoring

    // MARK: init

    init(permissionsService: PhotoPermissionChecking, store: BabyProfileStoring)
    {
        self.permissionsService = permissionsService
        self.store = store
        loadSavedProfile()
    }

    // MARK: Form Logic

    var isFormValid: Bool {
        !babyName.trimmingCharacters(in: .whitespaces).isEmpty
            && birthday != nil
    }

    // MARK: Methods

    @MainActor
    func handleImagePicked(_ image: UIImage?) {
        selectedImage = image
    }

    @MainActor
    func prepareImagePicker(for source: ImageSource) async throws {
        try await permissionsService.checkPermission(for: source)
        currentSource = source
    }

    // MARK: Persistency

    func saveProfile() {
        guard let birthday else { return }

        let filename = UUID().uuidString + ".jpg"
        let profile = BabyProfile(
            name: babyName,
            birthday: birthday,
            imageFilename: filename
        )

        do {
            try store.save(profile, image: selectedImage)
        } catch {
            profileError = .saveFailed(error.localizedDescription)
        }
    }

    func loadSavedProfile() {
        do {
            let (profile, image) = try store.load()
            babyName = profile.name
            birthday = profile.birthday
            self.selectedImage = image
        } catch BabyProfileStoreError.noProfile {
            //First launch - do nothing
        } catch {
            profileError = .saveFailed(error.localizedDescription)
        }
    }

    func showBirthdayScreen() {
        //TODO: Implement navigation
        saveProfile()
    }
}
