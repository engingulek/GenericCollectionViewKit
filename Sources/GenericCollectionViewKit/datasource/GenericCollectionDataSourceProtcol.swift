//
//  CollectionViewDataSourceProtcol.swift
//  GenericCollectionViewKit
//
//  Created by Engin Gülek on 11.11.2025.
//

import Foundation
import UIKit

//MARK: GenericCollectionViewDataSourceProtcol
/// B2-C1 English: A generic protocol for providing data to a UICollectionView.
/// It defines the required methods for sections, items, and optional section headers with buttons.
public protocol GenericCollectionDataSourceProtocol {
    /// Represents the type of data model that each collection view cell will display.
    associatedtype CellItem
    
    /// Returns the number of rows/items in a specific section.
    /// - Parameter section: The index of the section.
    /// - Returns: The number of items in that section.
    func numberOfRowsInSection(in section: Int) -> Int
    
    /// Returns the data model for a specific item in a section.
    /// - Parameters:
    ///   - section: The index of the section.
    ///   - item: The index of the item in the section.
    /// - Returns: The data model associated with the item.
    /// Türkçe: Bir bölümdeki belirli bir öğe için veri modelini döner.
    func cellForItem(section: Int, item: Int) -> CellItem
    
    /// Returns the total number of sections in the collection view.
    /// - Returns: Number of sections.
    func numberOfSections() -> Int
    
    /// Returns the cell reuse identifier for a specific section.
    /// - Parameter section: The index of the section.
    /// - Returns: The reuse identifier string for cells in this section.
    func cellIdentifier(at section: Int) -> String
    
    // MARK: - Optional Methods
    
    /// Returns the title and optional buttons for a section header.
    /// - Parameter section: The index of the section.
    /// - Returns: A tuple containing the title, size type, and optional button types.
    func titleForSection(at section: Int) -> (title: String,
                                              sizeType: SectionSizeType,
                                              buttonType: [TitleForSectionButtonType]?)
    
    /// Handles the action when a section header button is tapped.
    /// - Parameters:
    ///   - buttonType: The type of button tapped.
    ///   - section: The index of the section where the button was tapped.
    func onTappedTitleButton(buttonType: TitleForSectionButtonType, section: Int)
}

// MARK: - Default Implementation
public extension GenericCollectionDataSourceProtocol {
    
    /// Provides a default empty title and no buttons for a section.
    /// - Parameter section: The index of the section.
    /// - Returns: Default tuple with empty title, small size, and nil buttons.
    func titleForSection(at section: Int) -> (title: String,
                                              sizeType: SectionSizeType,
                                              buttonType: [TitleForSectionButtonType]?) {
        return ("", .small, nil)
    }
    
    /// Provides a default empty action for header buttons.
    /// - Parameters:
    ///   - buttonType: The type of button tapped.
    ///   - section: The index of the section.
    func onTappedTitleButton(buttonType: TitleForSectionButtonType, section: Int) { }
}

// MARK: - Generic Data Source Class
/// A generic UICollectionViewDataSource implementation using a data source conforming to GenericCollectionViewDataSourceProtcol.
public class GenericCollectionDataSource<Source: GenericCollectionDataSourceProtocol>:
    NSObject, UICollectionViewDataSource {
    
    private var source: Source
    private let configurator: (String, UICollectionViewCell, Any) -> Void
    
    /// Initializes the generic data source with a source and configurator closure.
    /// - Parameters:
    ///   - source: The data source conforming to GenericCollectionViewDataSourceProtcol.
    ///   - configurator: Closure that configures each cell using its identifier and item.
    public init(source: Source,
                configurator: @escaping (String, UICollectionViewCell, Any) -> Void) {
        self.source = source
        self.configurator = configurator
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        source.numberOfSections()
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
        
        source.numberOfRowsInSection(in: section)
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier = source.cellIdentifier(at: indexPath.section)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        let item = source.cellForItem(section: indexPath.section, item: indexPath.item)
        configurator(identifier, cell, item)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               viewForSupplementaryElementOfKind kind: String,
                               at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: String(describing: CHeaderView.self),
            for: indexPath) as? CHeaderView else {
            fatalError("Header view dequeue error")
        }
        
        let item = source.titleForSection(at: indexPath.section)
        
        header.configure(
            with: (title: item.title, sizeType: item.sizeType, buttonTypes: item.buttonType)
        ) { [weak self] tappedType in
            guard let self else { return }
            source.onTappedTitleButton(buttonType: tappedType, section: indexPath.section)
        }
        
        return header
    }
}

