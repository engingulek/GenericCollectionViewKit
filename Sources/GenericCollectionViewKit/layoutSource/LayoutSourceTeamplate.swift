//
//  LayoutSourceTeamplate.swift
//  GenericCollectionViewKit
//
//  Created by Engin Gülek on 11.11.2025.
//

import Foundation

// MARK: - LayoutSourceTemplate
/// Provides predefined layout templates for commonly used collection view layouts.
public enum LayoutSourceTeamplate {
    case horizontalSingleRow
    case verticalTwoPerRow
    case none
    
    /// Returns a predefined layout configuration based on the selected template type.
    public var template: LayoutSource {
        switch self {
        case .horizontalSingleRow:
            // Horizontal scrolling layout with one row of items that stretch across the width.
            return LayoutSource(
                groupOrientation: .horizontal,
                itemSize: .init(width: (type: .fractional, value: 0.95), height: (type: .fractional, value: 1.0)),
                groupSize: .init(width: (type: .fractional, value: 1.0), height: (type: .fractional, value: 0.25)),
                sectionInsets: (top: 10, leading: 10, bottom: 10, trailing: 10),
                interItemSpacing: 10,
                interGroupSpacing: 10,
                scrollDirection: .horizontal,
                isSticky: false
                
            )
            
        case .verticalTwoPerRow:
            // Vertical scrolling layout displaying two items per row.
            return LayoutSource(
                groupOrientation: .horizontal,
                itemSize: .init(width: (type: .fractional, value: 1.0 / 2), height: (type: .fractional, value: 1.0)),
                groupSize: .init(width: (type: .fractional, value: 1.0), height: (type: .fractional, value: 0.40)),
                sectionInsets: (top: 10, leading: 5, bottom: 10, trailing: 5),
                interItemSpacing: 5,
                interGroupSpacing: 8,
                scrollDirection: .vertical,
                isSticky: false
                
            )
            
        case .none:
            // Empty layout with no sizing or spacing — used as a placeholder.
            return LayoutSource(
                groupOrientation: .horizontal,
                itemSize: .init(width: (type: .none, value: 0), height: (type: .none, value: 0)),
                groupSize: .init(width: (type: .none, value: 0), height: (type: .none, value: 0)),
                sectionInsets: (top: 0, leading: 0, bottom: 0, trailing: 0),
                interItemSpacing: 0,
                interGroupSpacing: 0,
                scrollDirection: .vertical,
                isSticky:  false
            )
        }
    }
}
