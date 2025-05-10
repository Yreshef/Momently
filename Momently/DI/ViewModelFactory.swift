//
//  ViewModelFactory.swift
//  Momently
//
//  Created by Yohai on 07/05/2025.
//

import UIKit

final class ViewModelFactory {
    
    private let container: DependencyProviding
    
    init(container: DependencyProviding) {
        self.container = container
    }
    
    func makeMomentlyDetailViewModel() -> MomentlyDetailViewModel {
        return MomentlyDetailViewModel(permissionsService: container.permissionsService,
                                       store: BabyProfileStore(persistence: container.persistenceService),
                                       buildBirthdayViewModel: makeBirthdayViewModel
                                       )
    }
    
    func makeBirthdayViewModel(profile: BabyProfile, image: UIImage?) -> MomentlyBirthdayViewModel {
        MomentlyBirthdayViewModel(profile: profile, image: image)
    }
}
