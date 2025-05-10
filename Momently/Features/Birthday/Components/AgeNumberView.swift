//
//  AgeNumberView.swift
//  Momently
//
//  Created by Yohai on 09/05/2025.
//

import SwiftUI

struct AgeNumberView: View {
    let numberImageName: String

    var body: some View {
        HStack(spacing: 22) {
            Image("left_swirls")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 44)

            Image(numberImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 50.5, height: 88)

            Image("right_swirls")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 44)
        }
    }
}

#Preview {
    AgeNumberView(numberImageName: "birthday_age_1")
}



