//
//  enums.swift
//  GenericCollectionViewKit
//
//  Created by Engin Gülek on 11.11.2025.
//

import Foundation
import UIKit

public enum SectionSizeType {
    case large, medium, small,empty
    
    var size: CGFloat {
        switch self {
        case .large: return 25
        case .medium: return 23
        case .small: return 20
        case .empty: return 0
        }
    }
}

public enum TitleForSectionButtonType {
    case allList
    case custom(String)
    var title: String {
        switch self {
        case .allList:
            return "All List"
        case .custom(let title):
            return title
        }
    }
}


public enum TitleIconType {
    case systemImage(String)
    case imageAsstes(String)
}

public struct TitleIcon {
    let image:TitleIconType
    let tintColor:UIColor
}
