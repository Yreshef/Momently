//
//  PermissionService.swift
//  Momently
//
//  Created by Yohai on 08/05/2025.
//

import AVFoundation
import Photos
import UIKit

protocol PhotoPermissionChecking {
    func checkPermission(for source: ImageSource) async throws
}

struct PermissionService: PhotoPermissionChecking {
    func checkPermission(for source: ImageSource) async throws {
        switch source {
        case .camera: try await checkCameraPermissions()
        case .photoLibrary: try await checkPhotoLibraryPermissions()
        }
    }

    private func checkCameraPermissions() async throws {
        guard await UIImagePickerController.isSourceTypeAvailable(.camera) else {
            throw PhotoAccessError.cameraUnavailable
        }

        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            return
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            guard granted else {
                throw PhotoAccessError.cameraAccessDenied
            }
        default:
            throw PhotoAccessError.cameraAccessDenied
        }
    }

    private func checkPhotoLibraryPermissions() async throws {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .authorized, .limited:
            return
        case .notDetermined:
            let newStatus = await PHPhotoLibrary.requestAuthorization(
                for: .readWrite)
            guard newStatus == .authorized || newStatus == .limited else {
                throw PhotoAccessError.photoAccessDenied
            }
        default:
            throw PhotoAccessError.photoAccessDenied
        }
    }
}
