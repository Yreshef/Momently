//
//  BirthdayHeaderView.swift
//  Momently
//
//  Created by Yohai on 09/05/2025.
//

import SwiftUI

struct BirthdayHeaderView: View {
    
    @ObservedObject var viewModel: MomentlyBirthdayViewModel

    var body: some View {
        VStack(spacing: 0) {
            Text("TODAY \(viewModel.displayName.uppercased()) IS")
                .font(.system(size: 20))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
            
            Spacer().frame(height: 13)

            AgeNumberView(numberImageName: viewModel.ageImageName)
            
            Spacer().frame(height: 14)

            Text("\(viewModel.ageUnitText.uppercased()) OLD!")
                .font(.system(size: 20))
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    BirthdayHeaderView(viewModel: PreviewViewModelFactory.makeBirthdayViewModel())
}
