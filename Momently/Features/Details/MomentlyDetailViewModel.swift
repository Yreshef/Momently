//
//  MomentlyDetailViewModel.swift
//  Momently
//
//  Created by Yohai on 07/05/2025.
//

import Combine
import SwiftUI

enum MomentlyPresentation: Identifiable {
    case imagePicker
    case datePicker
    case photoSourceDialog
    case alert(title: String, message: String)

    case birthdayScreen(MomentlyBirthdayViewModel)

    var id: String {
        switch self {
        case .imagePicker: return "imagePicker"
        case .datePicker: return "datePicker"
        case .photoSourceDialog: return "photoSourceDialog"
        case .alert(let title, _): return title

        case .birthdayScreen: return "birthdayScreen"
        }
    }
}

final class MomentlyDetailViewModel: ObservableObject {

    typealias BirthdayViewModelBuilder = (BabyProfile, UIImage?) ->
        MomentlyBirthdayViewModel

    // MARK: Published Properties

    @Published var babyName: String = ""
    @Published var birthday: Date? = nil
    @Published var selectedImage: UIImage? = nil

    @Published var presentation: MomentlyPresentation?

    // MARK: Dependencies

    private let permissionsService: PhotoPermissionChecking
    private let store: BabyProfileStoring
    private let buildBirthdayViewModel: BirthdayViewModelBuilder

    var birthdayDisplay: String {
        birthday?.formatted(date: .abbreviated, time: .omitted)
            ?? "Select a Date"
    }

    var currentSource: ImageSource = .photoLibrary

    private var calculatedAge: Int? {
        guard let birthday else { return nil }
        let calendar = Calendar.current
        return calendar.dateComponents([.year], from: birthday, to: Date()).year
    }
    private let maxSupportedAge = 12

    // MARK: init

    init(
        permissionsService: PhotoPermissionChecking, store: BabyProfileStoring,
        buildBirthdayViewModel: @escaping BirthdayViewModelBuilder
    ) {
        self.permissionsService = permissionsService
        self.store = store
        self.buildBirthdayViewModel = buildBirthdayViewModel
        loadSavedProfile()
    }

    // MARK: Form Logic

    var isFormComplete: Bool {
        !babyName.trimmingCharacters(in: .whitespaces).isEmpty
            && birthday != nil
    }

    // MARK: Photo Picker

    @MainActor
    func handleImagePicked(_ image: UIImage?) {
        if let image = image {
            selectedImage = image
        } else {
            //Log user interaction
            print("User cancelled image picking")
        }
    }

    @MainActor
    func prepareImagePicker(for source: ImageSource) async {
        do {
            try await permissionsService.checkPermission(for: source)
            presentation = nil
            currentSource = source

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.presentation = .imagePicker
            }
        } catch let error as PhotoAccessError {
            presentation = .alert(
                title: "Permission Denied",
                message: error.localizedDescription
            )
        } catch {
            presentation = .alert(
                title: "Image Picker Error",
                message: "An unexpected error occurred."
            )
        }
    }

    func showPhotoSourceDialog() {
        presentation = .photoSourceDialog
    }

    // MARK: Persistency

    @discardableResult
    func saveProfile() -> BabyProfile? {
        guard let birthday else { return nil }

        let filename = UUID().uuidString + ".jpg"
        let profile = BabyProfile(
            name: babyName,
            birthday: birthday,
            imageFilename: filename
        )

        do {
            try store.save(profile, image: selectedImage)
            return profile
        } catch {
            presentation = .alert(
                title: "Save Failed",
                message: error.localizedDescription
            )
            return nil
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
            presentation = .alert(
                title: "Load Failed",
                message: error.localizedDescription)
        }
    }

    // MARK: Navigation

    @MainActor
    func saveAndShowBirthday() {
        guard isFormComplete else {
            presentation = .alert(
                title: "Missing Information",
                message: "Please enter both a name and a birthday."
            )
            return
        }
        guard let age = calculatedAge, age <= maxSupportedAge else {
            presentation = .alert(
                title: "Unsupported Age",
                message:
                    "Momently currently supports children up to age \(maxSupportedAge)."
            )
            return
        }

        if let profile = saveProfile() {
            let vm = buildBirthdayViewModel(profile, selectedImage)
            presentation = .birthdayScreen(vm)
        }
    }
}
