//
//  MomentlyApp.swift
//  Momently
//
//  Created by Yohai on 07/05/2025.
//

import SwiftUI

@main
struct MomentlyApp: App {
    
    let container: DependencyProviding = DependencyContainer()
    let viewModelFactory: ViewModelFactory
    
    init() {
        viewModelFactory = ViewModelFactory(container: container)
    }
    
    var body: some Scene {
        WindowGroup {
            MomentlyDetailView(viewModel: viewModelFactory.makeMomentlyDetailViewModel())
        }
    }
}
