# 🧩 Generic Collection View Framework

A lightweight and reusable framework for **UICollectionView** written in Swift.  
It provides a **generic**, **type-safe**, and **highly customizable** way to manage collection view data, section headers, delegates, and layouts. Compatible with **Swift 5.9+ / iOS 14+**.

---

## ✨ Features

- ✅ Generic and reusable `UICollectionViewDataSource`  
- ✅ Generic and reusable `UICollectionViewDelegate`  
- ✅ Generic and reusable `UICollectionViewCompositionalLayout`  
- ✅ Clean protocol-oriented architecture  
- ✅ Supports dynamic section headers (titles + buttons)  
- ✅ Strongly typed, type-safe, and fully generic  
- ✅ Predefined layout templates for common scenarios  
- ✅ Minimal boilerplate with default implementations

| Feature                   | Description                                                                         |
| ------------------------- | ----------------------------------------------------------------------------------- |
| 🧩 **Type Safety**        | Strong typing everywhere ensures no `AnyObject` confusion                           |
| ⚡ **Reusable**            | Write once, reuse across multiple collection views, headers, delegates, and layouts |
| 🧼 **Clean Architecture** | Separates data, layout, delegate, and UI logic                                      |
| 🧠 **Extensible**         | Easily extend with default methods, custom buttons, or layout templates             |

---

## 📜 CHeaderView
A **customizable section header** that supports a **title** ,**optional action buttons** and **optional icon for title**, making it easy to display section information dynamically.  
- A dynamic title (bold, resizable font)
- Optiona left-aligned icon
- Optional right-aligned buttons (e.g., “All List”, custom actions)
- Auto-layout with UIStackView
- Button tap callback closure

  ### HeaderIcon
 Defines the icon displayed next to the title.
```swift

public enum TitleIconType {
    case systemImage(String) // SF Symbols
    case imageAsstes(String) // Asset Catalog images
}

public struct HeaderIcon {
    public let image: TitleIconType
    public let tintColor: HeaderItemColor
}

```

 ### HeaderViewItem
 The main configuration model for CHeaderView.
```swift
public struct HeaderViewItem {
    public let title: String // Header title text
    public var icon: HeaderIcon? // Optional title icon
    public let sizeType: SectionSizeType // Header size / font style
    public var buttonTypes: [TitleForSectionButtonType] // Action buttons displayed on the right
}

```
 ### Configure
```swift
 header.configure(with: .init(
            title: item.title,
            icon: item.icon,
            sizeType: item.sizeType,
            buttonTypes: item.buttonTypes)) { [weak self] tappedType in
                guard let self else { return }
                source.onTappedTitleButton(buttonType: tappedType, section: indexPath.section)
            }
```
---

## GenericCollectionDataSourceProtocol
A **protocol-oriented**, **type-safe**, and **reusable** approach for managing collection view data.  
Defines a clean contract for `UICollectionView` data handling — sections, cells, and optional headers.

```swift
public protocol GenericCollectionDataSourceProtocol {
    associatedtype CellItem
    
    func numberOfSections() -> Int
    func numberOfRowsInSection(in section: Int) -> Int
    func cellForItem(section: Int, item: Int) -> CellItem
    func cellIdentifier(at section: Int) -> String
    func titleForSection(at section: Int) -> (
        title: String,
        sizeType: SectionSizeType,
        buttonType: [TitleForSectionButtonType]?
    )
    func onTappedTitleButton(buttonType: TitleForSectionButtonType, section: Int)
}
```
### Default Implementations

```swift
func titleForSection(at section: Int) -> HeaderViewItem
func onTappedTitleButton(buttonType: TitleForSectionButtonType, section: Int) { }
}
```

### Supporting Types

SectionSizeType
Controls the font size for section titles:

```swift
public enum SectionSizeType {
    case large, medium, small
    var size: CGFloat { ... }
}

```

TitleForSectionButtonType
Represents possible header button types:

```swift
public enum TitleForSectionButtonType {
    case allList
    case custom(String)
    var title: String { ... }
}
```

###  Example Usage 

```swift
struct MyModel { let name: String }

final class MyCollectionDataSource: GenericCollectionDataSourceProtocol {
    typealias CellItem = MyModel
    
    func numberOfSections() -> Int { 2 }
    func numberOfRowsInSection(in section: Int) -> Int { 5 }
    func cellForItem(section: Int, item: Int) -> MyModel { MyModel(name: "Item \(item)") }
    func cellIdentifier(at section: Int) -> String { "MyCell" }
    
    func titleForSection(at section: Int) -> (
        title: String,
        sizeType: SectionSizeType,
        buttonType: [TitleForSectionButtonType]?
    ) {
        (title: "Section \(section)", sizeType: .medium, buttonType: [.allList, .custom("Filter")])
    }
    
    func onTappedTitleButton(buttonType: TitleForSectionButtonType, section: Int) {
        print("Tapped \(buttonType) in section \(section)")
    }
}

```

### Integration Example


```swift
let mySource = MyCollectionDataSource()
let dataSource = GenericCollectionDataSource(source: mySource) { identifier, cell, item in
    guard let cell = cell as? MyCollectionViewCell,
          let model = item as? MyModel else { return }
    cell.configure(with: model)
}

collectionView.dataSource = dataSource
```

## Generic Collection Delegate Source Protocol

A lightweight and reusable UICollectionView delegate written in Swift.
It provides **a generic, type-safe, and protocol-oriented** way to handle item selection and scroll events in collection views.

```swift
public protocol GenericCollectionDelegateSourceProtocol {
    func didSelectItem(section: Int, item: Int)
    func scrollViewDidScroll(endOfPage: Bool)
}
```

### Default Implementations
```swift
public extension GenericCollectionDelegateSourceProtocol {
    func scrollViewDidScroll(endOfPage: Bool) { }
    func didSelectItem(section: Int, item: Int) { }
}
```

### Example Usage
```swift
final class MyDelegateSource: GenericCollectionDelegateSourceProtocol {
    func didSelectItem(section: Int, item: Int) { print("Selected item \(item) in section \(section)") }
    func scrollViewDidScroll(endOfPage: Bool) { if endOfPage { print("Reached end of page ✅") } }
}
```

### Integration Example

```swift
let source = MyDelegateSource()
let delegate = GenericCollectionDelegate(source: source)
collectionView.delegate = delegate
```

## Generic Collection Layout Provider Protocol
A lightweight and reusable UICollectionViewCompositionalLayout framework written in Swift.
Provides **a generic, type-safe, and flexible** way to configure collection view layouts.

```swift
public protocol GenericCollectionLayoutProviderProtocol {
    func layout(for sectionIndex: Int) -> LayoutSource
}
```
### LayoutSource

Describes the structure and behavior of the layout:

```swift
public struct LayoutSource {
    public init(groupOrientation: ScrollDirection,
                itemSize: SizeInfo,
                groupSize: SizeInfo,
                sectionInsets: (top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat),
                interItemSpacing: CGFloat,
                interGroupSpacing: CGFloat,
                scrollDirection: ScrollDirection) { ... }
}

```

#### Supporting Types
```swift
public enum DimensionType { case fractional, absolute, none }

public struct SizeInfo {
    let width: (type: DimensionType, value: CGFloat)
    let height: (type: DimensionType, value: CGFloat)
}

public enum ScrollDirection { case horizontal, vertical }
```

### Example Usage

```swift
final class MyLayoutSource: GenericCollectionLayoutProviderProtocol {
    func layout(for sectionIndex: Int) -> LayoutSource {
        switch sectionIndex {
        case 0: return LayoutSourceTeamplate.horizontalSingleRow.template
        case 1: return LayoutSourceTeamplate.verticalTwoPerRow.template
        default: return LayoutSourceTeamplate.none.template
        }
    }
}

let layoutProvider = GenericCollectionLayoutProvider(source: MyLayoutSource())
let layout = layoutProvider.createLayout()
let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

```
## Tutorial Video


<table>
  <tr>
    <td>
     <video width="320" height="140" src = "https://github.com/user-attachments/assets/8f652c61-6440-4757-8431-025c4549274d">
    </td>
    <td>
    <video width="320" height="140" src = "https://github.com/user-attachments/assets/483a0e53-5a24-4890-af49-0425c015d90c">
    </td>
  </tr>
</table>


## 🧰 Installation

```swift

dependencies: [
.package(url: "https://github.com/engingulek/GenericCollectionViewKit.git", from: "0.0.2")
]

```

