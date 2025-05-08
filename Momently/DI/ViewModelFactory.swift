//
//  ViewModelFactory.swift
//  Momently
//
//  Created by Yohai on 07/05/2025.
//

import Foundation

final class ViewModelFactory {
    
    private let container: DependencyProviding
    
    init(container: DependencyProviding) {
        self.container = container
    }
    
    func makeMomentlyDetailViewModel() -> MomentlyDetailViewModel {
        return MomentlyDetailViewModel(permissionsService: container.permissionsService,
                                       store: BabyProfileStore(persistence: container.persistenceService)
                                       )
    }
}
