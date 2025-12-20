//
//  HeaderItemColor.swift
//  GenericCollectionViewKit
//
//  Created by Engin Gülek on 15.12.2025.
//
import UIKit

// MARK: - HeaderItemColor
public enum HeaderItemColor  {
    case primary
    case secondary
    case danger
    case custom(hex: String)
}


public extension HeaderItemColor {
    var uiColor: UIColor {
        switch self {
        case .primary:
            return .systemBlue
        case .secondary:
            return .systemGray
        case .danger:
            return .systemRed
        case .custom(let hex):
            return UIColor(hex: hex) ?? .black
        }
    }
}
