//
//  HeaderViewItem.swift
//  GenericCollectionViewKit
//
//  Created by Engin Gülek on 15.12.2025.
//
import UIKit

//MARK: TitleIconType
public enum TitleIconType {
    case systemImage(String)
    case imageAsstes(String)
   
}

public struct TitleIcon {

    public let image: TitleIconType
    public let tintColor: HeaderItemColor

    public init(
        image: TitleIconType,
        tintColor: HeaderItemColor
    ) {
        self.image = image
        self.tintColor = tintColor
    }
}

//MARK: HeaderViewItem
public struct HeaderViewItem {

    public let title: String
    public var icon: TitleIcon? = nil
    public let sizeType: SectionSizeType
    public var buttonTypes: [TitleForSectionButtonType] = []

    public init(
        title: String,
        icon: TitleIcon? = nil,
        sizeType: SectionSizeType,
        buttonTypes: [TitleForSectionButtonType] = []
    ) {
        self.title = title
        self.icon = icon
        self.sizeType = sizeType
        self.buttonTypes = buttonTypes
    }
}
