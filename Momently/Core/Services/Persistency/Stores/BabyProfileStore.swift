//
//  BabyProfileStore.swift
//  Momently
//
//  Created by Yohai on 08/05/2025.
//

import UIKit

struct BabyProfileStore: BabyProfileStoring {

    private let profileKey = "baby_profile"

    private let persistence: PersistenceService

    init(persistence: PersistenceService) {
        self.persistence = persistence
    }

    func save(_ profile: BabyProfile, image: UIImage?) throws {
        try persistence.save(profile, forKey: profileKey)
        if let filename = profile.imageFilename, let image = image {
            try persistence.saveImage(image, named: filename)
        }
    }

    func load() throws -> (profile: BabyProfile, image: UIImage?) {
        guard let profile = try? persistence.load(forKey: profileKey, as: BabyProfile.self) else {
            throw BabyProfileStoreError.noProfile
        }
        let image = profile.imageFilename.flatMap {
            persistence.loadImage(named: $0)
        }
        return (profile, image)
    }
}
