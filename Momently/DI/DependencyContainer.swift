//
//  DependencyContainer.swift
//  Momently
//
//  Created by Yohai on 07/05/2025.
//

import Foundation

protocol DependencyProviding {
    var permissionsService: PhotoPermissionChecking { get }
    var persistenceService: PersistenceService { get }
}

final class DependencyContainer: DependencyProviding {
    
    var permissionsService: PhotoPermissionChecking = PermissionService()
    var persistenceService: PersistenceService = DefaultPeristenceService()
    
    init() { }
    
}
