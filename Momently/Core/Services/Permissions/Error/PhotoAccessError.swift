//
//  PhotoAccessError.swift
//  Momently
//
//  Created by Yohai on 08/05/2025.
//

import Foundation

enum PhotoAccessError: Error, LocalizedError {
    case cameraUnavailable
    case cameraAccessDenied
    case photoAccessDenied
    case unknown

    var errorDescription: String? {
        switch self {
        case .cameraUnavailable:
            return "Camera is not available on this device."
        case .cameraAccessDenied:
            return "Camera access is denied. Please enable it in Settings."
        case .photoAccessDenied:
            return "Photo library access is denied. Please enable it in Settings."
        case .unknown:
            return "An unknown error occurred while accessing photos."
        }
    }
}
