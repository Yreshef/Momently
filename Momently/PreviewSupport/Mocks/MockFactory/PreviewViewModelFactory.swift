//
//  PreviewViewModelFactory.swift
//  Momently
//
//  Created by Yohai on 07/05/2025.
//

import UIKit

enum PreviewViewModelFactory {
    static func makeDetailViewModel() -> MomentlyDetailViewModel {
        let vm = MomentlyDetailViewModel(
            permissionsService: MockPermissionService(mode: .allowAll),
            store: MockBabyProfileStore())
        vm.babyName = "Lionel Messi"
        vm.birthday = Calendar.current.date(
            byAdding: .year, value: -30, to: Date())
        vm.selectedImage = UIImage(systemName: "BabyPlaceholderGreen")
        return vm
    }

    static func makeBirthdayViewModel() -> MomentlyBirthdayViewModel {
        let profile = BabyProfile(
            name: "Dutchie",
            birthday: Calendar.current.date(
                byAdding: .month, value: -6, to: Date())!,
            imageFilename: nil
        )
        let image = UIImage(systemName: "baby_default_1")
        return MomentlyBirthdayViewModel(profile: profile, image: image)
    }
}
