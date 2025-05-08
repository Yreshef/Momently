//
//  MockPermissionService.swift
//  Momently
//
//  Created by Yohai on 08/05/2025.
//

import Foundation

final class MockPermissionService: PhotoPermissionChecking {
    enum Mode {
        case allowAll
        case denyAll
        case custom((ImageSource) -> Result<Void, PhotoAccessError>)
    }

    private let mode: Mode

    init(mode: Mode = .allowAll) {
        self.mode = mode
    }

    func checkPermission(for source: ImageSource) async throws {
        switch mode {
        case .allowAll:
            return

        case .denyAll:
            throw error(for: source)

        case .custom(let logic):
            switch logic(source) {
            case .success: return
            case .failure(let error): throw error
            }
        }
    }

    private func error(for source: ImageSource) -> PhotoAccessError {
        switch source {
        case .camera: return .cameraAccessDenied
        case .photoLibrary: return .photoAccessDenied
        }
    }
}
