//
//  GenericCollectionLayoutProtocol.swift
//  GenericCollectionViewKit
//
//  Created by Engin Gülek on 11.11.2025.
//

import UIKit
import Foundation

// MARK: - GenericCollectionLayoutProviderProtocol
/// A protocol that defines how layout configurations are provided for each section
/// of a collection view. Each section can have its own distinct layout style by returning
/// a `LayoutSource` instance.
public protocol GenericCollectionLayoutProviderProtocol {
    
    ///Returns a layout configuration (`LayoutSource`) for the specified section index.
    /// - Parameter sectionIndex: The index of the section whose layout is being requested.
    /// - Returns: A `LayoutSource` instance describing the layout configuration for that section.
    func layout(for sectionIndex: Int) -> LayoutSource
}

// MARK: - GenericCollectionLayoutProvider
/// A generic class that builds a `UICollectionViewCompositionalLayout`
/// using the configurations provided by a `GenericCollectionLayoutProviderProtocol` conforming source.
public class GenericCollectionLayoutProvider<Source: GenericCollectionLayoutProviderProtocol> {
    
    ///The source responsible for providing layout configurations per section.
    private let source: Source
    
    /// Initializes a new instance of `GenericCollectionLayoutProvider` with a layout source.
    /// - Parameter source: An object conforming to `GenericCollectionLayoutProtocol`.
    public init(source: Source) {
        self.source = source
    }
    
    // MARK: - Layout Creation
    /// Creates and returns a `UICollectionViewCompositionalLayout`
    /// based on the layout information provided by the source.
    /// This method dynamically constructs section layouts using each section’s `LayoutSource`.
    /// It handles item sizing, grouping, spacing, section insets, scroll direction, and headers.
    /// - Returns: A fully configured `UICollectionViewCompositionalLayout`.
    @MainActor
    public func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            
            // Retrieve layout configuration for the current section
            let layoutSource = self.source.layout(for: sectionIndex)
            
            // MARK: Item Configuration
            /// Define how individual items are sized (fractional , absolute or estimated).
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: makeLayoutDimension(
                    type: layoutSource.itemSize.width.type,
                    value: layoutSource.itemSize.width.value,
                    isWidth: true
                ),
                heightDimension: makeLayoutDimension(
                    type: layoutSource.itemSize.height.type,
                    value: layoutSource.itemSize.height.value,
                    isWidth: false
                )
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            
            // MARK: Group Configuration
            /// Define the layout and size of item groups (either horizontal or vertical).
            let groupSize = NSCollectionLayoutSize(
                widthDimension: makeLayoutDimension(
                    type: layoutSource.groupSize.width.type,
                    value: layoutSource.groupSize.width.value,
                    isWidth: true
                ),
                heightDimension: makeLayoutDimension(
                    type: layoutSource.groupSize.height.type,
                    value: layoutSource.groupSize.height.value,
                    isWidth: false
                )
            )
            
            
            let group: NSCollectionLayoutGroup
            if layoutSource.groupOrientation == .horizontal {
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            } else {
                group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            }
            
            group.interItemSpacing = .fixed(layoutSource.interItemSpacing)
            
            // MARK: Section Configuration
            /// Defines how groups are arranged within each section, including
            /// scrolling behavior, content insets, spacing, and supplementary views.
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = layoutSource.scrollDirection == .horizontal ? .continuous : .none
            section.contentInsets = NSDirectionalEdgeInsets(
                top: layoutSource.sectionInsets.top,
                leading: layoutSource.sectionInsets.leading,
                bottom: layoutSource.sectionInsets.bottom,
                trailing: layoutSource.sectionInsets.trailing
            )
            section.interGroupSpacing = layoutSource.interGroupSpacing
            
            // MARK: Header Configuration
            /// Adds a header supplementary view at the top of each section.
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(40)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [sectionHeader]
            if layoutSource.isSticky {
                sectionHeader.pinToVisibleBounds = true
                sectionHeader.zIndex = 2
            }
            return section
        }
    }
    
    @MainActor
    func makeLayoutDimension(
        type: DimensionType,
        value: CGFloat,
        isWidth: Bool
    ) -> NSCollectionLayoutDimension {
        switch type {
        case .fractional:
            return isWidth
            ? .fractionalWidth(value)
            : .fractionalHeight(value)
            
        case .absolute:
            return .absolute(value)
            
        case .estimated:
            return .estimated(value)
        case .none:
            return .absolute(0)
        }
    }
    
}
