//
//  GenericCollectionDelegateSourceProtocol.swift
//  GenericCollectionViewKit
//
//  Created by Engin Gülek on 11.11.2025.
//

import UIKit
import Foundation

///  A protocol defining delegate methods for a generic UICollectionView,
/// handling item selection and scroll events.
public protocol GenericCollectionDelegateSourceProtocol {
    
    /// Called when a collection view item is selected.
    /// - Parameter indexPath: The index path of the selected item.
    func didSelectItem(at indexPath: IndexPath)
    
    ///Called when the scroll view scrolls, indicating whether the end of the page is reached.
    /// - Parameter endOfPage: True if the last item of the last section is visible, false otherwise.
    func scrollViewDidScroll(endOfPage: Bool)
}

// MARK: - Default Implementations
public extension GenericCollectionDelegateSourceProtocol {
    
    /// Default empty implementation for scroll events.
    /// - Parameter endOfPage: Indicates if the end of page is reached.
    func scrollViewDidScroll(endOfPage: Bool) { }
    
    /// Default empty implementation for item selection.
    /// - Parameter indexPath: The index path of the selected item.
    func didSelectItem(at indexPath: IndexPath) { }
}

// MARK: - Generic Delegate Class
/// A generic UICollectionViewDelegate implementation that connects delegate events
/// to a source conforming to GenericCollectionDelegateSourceProtcol.
public class GenericCollectionDelegate<Source: GenericCollectionDelegateSourceProtocol>:
    NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var source: Source
    
    ///Initializes the generic delegate with a source.
    /// - Parameter source: The object conforming to GenericCollectionDelegateSourceProtcol.
    public init(source: Source) {
        self.source = source
    }
    
    /// Called when a collection view item is selected, forwards the event to the source.
    /// - Parameters:
    ///   - collectionView: The collection view containing the selected item.
    ///   - indexPath: The index path of the selected item.
    public func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath) {
        source.didSelectItem(at: indexPath)
    }
    
    ///Called when a cell is about to be displayed. Detects if the user reached the end of the collection view.
    /// - Parameters:
    ///   - collectionView: The collection view displaying the cell.
    ///   - cell: The cell that will be displayed.
    ///   - indexPath: The index path of the cell.
    public func collectionView(_ collectionView: UICollectionView,
                               willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastSectionIndex = collectionView.numberOfSections - 1
        let lastItemIndex = collectionView.numberOfItems(inSection: lastSectionIndex) - 1

        if indexPath.section == lastSectionIndex && indexPath.item == lastItemIndex {
            source.scrollViewDidScroll(endOfPage: true)
        } else {
            source.scrollViewDidScroll(endOfPage: false)
        }
    }
}

