//
//  MomentlyBirthdayView.swift
//  Momently
//
//  Created by Yohai on 07/05/2025.
//

import SwiftUI

struct MomentlyBirthdayView: View {

    @ObservedObject var viewModel: MomentlyBirthdayViewModel
    @Environment(\.dismiss) private var dismiss
    private let backgroundIndex: Int
    private let theme: BirthdayTheme
    
    init(viewModel: MomentlyBirthdayViewModel, _ previewIndex: Int? = nil) {
        self.viewModel = viewModel
        self.backgroundIndex = previewIndex ?? Int.random(in: 1...3)
        self.theme = BirthdayTheme(rawValue: backgroundIndex) ?? .blue
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            backgroundLayer
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .zIndex(1)
                .ignoresSafeArea()
            VStack {
                BirthdayHeaderView(viewModel: viewModel)
                Spacer()
                Image("nanit_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 59, height: 20)
                    .padding(.bottom, 90)
            }
            .zIndex(2)
            BabyImageView(viewModel: viewModel, theme: theme)
                .padding(.bottom, 100)
       
        }
        .background(theme.backgroundColor)
        .safeAreaInset(edge: .top) {
            HStack(alignment: .center) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.black.opacity(0.5))
                        .padding(.horizontal, 12)
                        .contentShape(Rectangle())
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.leading, 8)
        }
    }
    
    private var backgroundLayer: some View {
        VStack(spacing: 0) {
            theme.backgroundImage
                .resizable()
                .scaledToFit()
                .frame(maxHeight: .infinity, alignment: .bottom)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

#Preview {
    MomentlyBirthdayView(
        viewModel: PreviewViewModelFactory.makeBirthdayViewModel())
}
