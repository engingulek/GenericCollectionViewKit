//
//  UIColor+Extensions.swift
//  GenericCollectionViewKit
//
//  Created by Engin Gülek on 15.12.2025.
//

import UIKit

public extension UIColor {

    /// Hex string ile UIColor üretir.
    /// Desteklenen formatlar:
    /// - "#RRGGBB"
    /// - "RRGGBB"
    /// - "#RRGGBBAA"
    /// - "RRGGBBAA"
    convenience init?(hex: String) {

        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexString = hexString.replacingOccurrences(of: "#", with: "")

        let length = hexString.count
        guard length == 6 || length == 8 else { return nil }

        var hexNumber: UInt64 = 0
        guard Scanner(string: hexString).scanHexInt64(&hexNumber) else {
            return nil
        }

        let r, g, b, a: CGFloat

        if length == 6 {
            r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255
            g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255
            b = CGFloat(hexNumber & 0x0000FF) / 255
            a = 1.0
        } else {
            r = CGFloat((hexNumber & 0xFF000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00FF0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000FF00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000FF) / 255
        }

        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
