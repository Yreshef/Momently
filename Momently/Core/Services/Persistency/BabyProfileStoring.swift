//
//  BabyProfileStoring.swift
//  Momently
//
//  Created by Yohai on 08/05/2025.
//

import UIKit

protocol BabyProfileStoring {
    func save(_ profile: BabyProfile, image: UIImage?) throws
    func load() throws -> (profile: BabyProfile, image: UIImage?)
}
