//
//  UIImage+Ext.swift
//  Momently
//
//  Created by Yohai on 10/05/2025.
//

import UIKit

extension UIImage {
    static func named(_ name: String, fallback: UIImage = UIImage()) -> UIImage {
        UIImage(named: name) ?? fallback
    }
}
