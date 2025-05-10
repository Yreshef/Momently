//
//  MomentlyBirthdayViewModel.swift
//  Momently
//
//  Created by Yohai on 07/05/2025.
//

import UIKit

final class MomentlyBirthdayViewModel: ObservableObject {

    private let profile: BabyProfile
    private var image: UIImage?
    
    private var numberImageName = "birthday_age_"

    @Published var ageString: String = ""
    @Published var displayName: String = ""
    @Published var displayImage: UIImage?
    @Published var ageNumber: Int = 0
    @Published var ageUnit: String = "Month"

    init(profile: BabyProfile, image: UIImage?) {
        self.profile = profile
        self.image = image
        self.computeState()
    }

    var ageImageName: String {
        "\(numberImageName)\(ageNumber)"
    }

    var ageUnitText: String {
        ageUnit.capitalized.pluralized(for: ageNumber)
    }

    func didTapChangeImage() {

    }

    private func computeState() {
        displayName = profile.name
        displayImage = image

        let age = computeAge(from: profile.birthday)
        ageNumber = age.number
        ageUnit = age.unit
    }

    private func computeAge(from birthDate: Date, to today: Date = Date()) -> (
        number: Int, unit: String
    ) {
        let calendar = Calendar.current
        let totalMonths =
            calendar.dateComponents([.month], from: birthDate, to: today).month
            ?? 0

        if totalMonths < 12 {
            return (number: totalMonths, unit: "Month")
        } else {
            return (number: totalMonths / 12, unit: "Year")
        }
    }
}
