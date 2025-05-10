//
//  BabyImageView.swift
//  Momently
//
//  Created by Yohai on 09/05/2025.
//

import SwiftUI

struct BabyImageView: View {
    
    @ObservedObject var viewModel: MomentlyBirthdayViewModel
    let backgroundIndex: Int

    var body: some View {
        Image(uiImage: viewModel.displayImage ?? UIImage(named: "baby_default_\(backgroundIndex)")!)
            .resizable()
            .scaledToFit()
            .frame(width: 220, height: 220)
            .clipShape(Circle())
            .shadow(radius: 10)
            .padding(.horizontal, 50)
    }
}

#Preview {
    BabyImageView(viewModel: PreviewViewModelFactory.makeBirthdayViewModel(), backgroundIndex: 1)
}
