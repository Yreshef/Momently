//
//  PersistenceService.swift
//  Momently
//
//  Created by Yohai on 08/05/2025.
//

import UIKit

protocol PersistenceService {
    func save<T: Codable>(_ object: T, forKey key: String) throws
    func load<T: Codable>(forKey key: String, as type: T.Type) throws -> T
    func saveImage(_ image: UIImage, named: String) throws
    func loadImage(named: String) -> UIImage?
}
