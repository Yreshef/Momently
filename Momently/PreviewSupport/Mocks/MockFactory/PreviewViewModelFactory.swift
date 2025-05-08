//
//  PreviewViewModelFactory.swift
//  Momently
//
//  Created by Yohai on 07/05/2025.
//

import UIKit


enum PreviewViewModelFactory {
    static func makeDetailViewModel() -> MomentlyDetailViewModel {
        let vm = MomentlyDetailViewModel()
        vm.babyName = "Lionel Messi"
        vm.birthday = Calendar.current.date(byAdding: .year, value: -30, to: Date())
        vm.selectedImage = UIImage(systemName: "BabyPlaceholderGreen")
        return vm
    }
}
