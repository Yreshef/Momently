//
//  BirthdayTheme.swift
//  Momently
//
//  Created by Yohai on 10/05/2025.
//

import SwiftUI
import UIKit

enum BirthdayTheme: Int, CaseIterable {
    case blue = 1
    case green = 2
    case yellow = 3

    static func from(index: Int) -> BirthdayTheme {
        self.init(rawValue: index) ?? .blue
    }

    var backgroundColor: Color {
        Color("birthday_\(colorName)")
    }

    var backgroundImage: Image {
        Image("birthday_bg_\(rawValue)")
    }

    var defaultAvatarName: String {
        "baby_default_\(rawValue)"
    }

    private var colorName: String {
        switch self {
        case .blue: return "blue"
        case .green: return "green"
        case .yellow: return "yellow"
        }
    }
}
