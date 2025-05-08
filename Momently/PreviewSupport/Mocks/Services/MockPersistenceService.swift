//
//  MockPersistenceService.swift
//  Momently
//
//  Created by Yohai on 08/05/2025.
//

import UIKit

final class MockPersistenceService: PersistenceService {
    
    private var dataStorage: [String : Data] = [:]
    private var imageStorage: [String : UIImage] = [:]
    
    func save<T>(_ object: T, forKey key: String) throws where T : Decodable, T : Encodable {
        let data = try JSONEncoder().encode(object)
        dataStorage[key] = data
    }
    
    func load<T>(forKey key: String, as type: T.Type) throws -> T where T : Decodable, T : Encodable {
        guard let data = dataStorage[key] else {
            throw NSError(domain: "MockPersistenceService",
                          code: 404,
                          userInfo: [NSLocalizedDescriptionKey: "No value found for key \(key)"])
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func saveImage(_ image: UIImage, named: String) throws {
        imageStorage[named] = image
    }
    
    func loadImage(named: String) -> UIImage? {
        return imageStorage[named]
    }
}
