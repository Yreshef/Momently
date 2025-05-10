//
//  BabyImageView.swift
//  Momently
//
//  Created by Yohai on 09/05/2025.
//

import SwiftUI

struct BabyImageView: View {
    
    @ObservedObject var viewModel: MomentlyBirthdayViewModel
    let theme: BirthdayTheme
    private var resolvedImage: UIImage {
        viewModel.displayImage ?? .named(theme.defaultAvatarName)
    }

    var body: some View {
        let size: CGFloat = 220
        Image(uiImage: resolvedImage)
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(theme.backgroundColor, lineWidth: 8)
            )
            .background(
                Circle()
                    .fill(theme.backgroundColor)
            )
            .shadow(radius: 10)
            .padding(.horizontal, 50)
    }
}

#Preview {
    BabyImageView(viewModel: PreviewViewModelFactory.makeBirthdayViewModel(), theme: BirthdayTheme(rawValue: 1) ?? .yellow)
}
