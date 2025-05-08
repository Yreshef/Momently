//
//  MockBabyProfileStore.swift
//  Momently
//
//  Created by Yohai on 08/05/2025.
//

import UIKit

final class MockBabyProfileStore: BabyProfileStoring {

    private var storedProfile: BabyProfile?
    private var storedImage: UIImage?

    func save(_ profile: BabyProfile, image: UIImage?) throws {
        self.storedProfile = profile
        self.storedImage = image
    }

    func load() throws -> (profile: BabyProfile, image: UIImage?) {
        guard let profile = storedProfile else {
            throw NSError(
                domain: "MockBabyProfileStore",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "No profile stored"]
            )
        }

        return (profile, storedImage)
    }
}
