//
//  DefaultPeristenceService.swift
//  Momently
//
//  Created by Yohai on 08/05/2025.
//

import UIKit

struct DefaultPeristenceService: PersistenceService {

    private let fileManager: FileManager
    private let userDefaults: UserDefaults
    
    private let imageFolder = "BabyImages"
    
    init(userDefaults: UserDefaults = .standard, fileManager: FileManager = .default) {
        self.fileManager = fileManager
        self.userDefaults = userDefaults
    }

    func save<T: Codable>(_ object: T, forKey key: String) throws {
        let data = try JSONEncoder().encode(object)
        userDefaults.set(data, forKey: key)
    }

    func load<T: Codable>(forKey key: String, as type: T.Type) throws -> T {
        guard let data = userDefaults.data(forKey: key) else {
            throw NSError(
                domain: "Persistence", code: 1,
                userInfo: [NSLocalizedDescriptionKey: "No data for key \(key)"])
        }
        return try JSONDecoder().decode(T.self, from: data)
    }

    func saveImage(_ image: UIImage, named: String) throws {
        guard let data = image.jpegData(compressionQuality: 0.9) else { return }
        let url = try imageURL(named: named)
        try data.write(to: url)
    }

    func loadImage(named: String) -> UIImage? {
        guard let url = try? imageURL(named: named) else { return nil }
        return UIImage(contentsOfFile: url.path)
    }

    private func imageURL(named name: String) throws -> URL {
        let directory = try fileManager.url(
            for: .documentDirectory, in: .userDomainMask,
            appropriateFor: nil, create: true
        ).appendingPathComponent(imageFolder, isDirectory: true)

        try fileManager.createDirectory(
            at: directory, withIntermediateDirectories: true)
        return directory.appendingPathComponent(name)
    }
}
