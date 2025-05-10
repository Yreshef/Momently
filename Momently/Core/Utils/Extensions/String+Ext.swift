//
//  String+Ext.swift
//  Momently
//
//  Created by Yohai on 09/05/2025.
//

import Foundation

extension String {
    func pluralized(for count: Int) -> String {
        count == 1 ? self : self + "s"
    }
}
