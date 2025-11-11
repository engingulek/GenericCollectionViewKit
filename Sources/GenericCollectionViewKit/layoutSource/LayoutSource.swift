//
//  LayoutSource.swift
//  GenericCollectionViewKit
//
//  Created by Engin Gülek on 11.11.2025.
//


import UIKit
import Foundation

// MARK: - DimensionType
/// Represents how a size dimension (width or height) is defined.
/// It can be fractional (relative to its container), absolute (fixed value), or none (no defined size).
public enum DimensionType {
    case fractional
    case absolute
    case none
}

// MARK: - SizeInfo
/// Encapsulates the width and height of an element using a specific `DimensionType` and a numeric value.
/// It allows flexible sizing for compositional layouts.
public struct SizeInfo {
    
    ///Initializes a new SizeInfo instance with specified width and height configurations.
    /// - Parameters:
    ///   - width: A tuple containing the dimension type and value for width.
    ///   - height: A tuple containing the dimension type and value for height.
    public init(width: (type: DimensionType, value: CGFloat),
                height: (type: DimensionType, value: CGFloat)) {
        self.width = width
        self.height = height
    }
    
    ///Width configuration consisting of a dimension type and a numeric value.
    let width: (type: DimensionType, value: CGFloat)
    
    ///Height configuration consisting of a dimension type and a numeric value.
    let height: (type: DimensionType, value: CGFloat)
}

// MARK: - ScrollDirection
/// Defines the direction in which the collection view scrolls — either horizontally or vertically.
public enum ScrollDirection {
    case horizontal
    case vertical
}

// MARK: - LayoutSource
/// A configuration model for creating compositional layouts in a collection view.
/// It defines item and group sizes, layout orientation, spacing, and scroll direction.
public struct LayoutSource {
    
    /// Initializes a new layout configuration with the given parameters.
    /// - Parameters:
    ///   - groupOrientation: The orientation of items within a group (horizontal or vertical).
    ///   - itemSize: The size configuration for individual items.
    ///   - groupSize: The size configuration for each group of items.
    ///   - sectionInsets: The spacing around each section (top, leading, bottom, trailing).
    ///   - interItemSpacing: The spacing between items within a group.
    ///   - interGroupSpacing: The spacing between groups.
    ///   - scrollDirection: The overall scrolling direction of the collection view.
    public init(
        groupOrientation: ScrollDirection,
        itemSize: SizeInfo,
        groupSize: SizeInfo,
        sectionInsets: (top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat),
        interItemSpacing: CGFloat,
        interGroupSpacing: CGFloat,
        scrollDirection: ScrollDirection
    ) {
        self.groupOrientation = groupOrientation
        self.itemSize = itemSize
        self.groupSize = groupSize
        self.sectionInsets = sectionInsets
        self.interItemSpacing = interItemSpacing
        self.interGroupSpacing = interGroupSpacing
        self.scrollDirection = scrollDirection
    }
    
    let groupOrientation: ScrollDirection
    let itemSize: SizeInfo
    let groupSize: SizeInfo
    let sectionInsets: (top: CGFloat,
                        leading: CGFloat,
                        bottom: CGFloat,
                        trailing: CGFloat)
    
    let interItemSpacing: CGFloat
    let interGroupSpacing: CGFloat
    let scrollDirection: ScrollDirection
}
