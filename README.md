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
A **customizable section header** that supports a **title** and **optional action buttons**, making it easy to display section information dynamically.  
- A dynamic title (bold, resizable font)
- Optional right-aligned buttons (e.g., “All List”, custom actions)
- Auto-layout with UIStackView
- Button tap callback closure
```swift
  header.configure(
    with: (title: "Recommended", sizeType: .medium, buttonTypes: [.allList, .custom("More")])
) { buttonType in
    print("Tapped:", buttonType)
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
public extension GenericCollectionDataSourceProtocol {
    func titleForSection(at section: Int) -> (
        title: String,
        sizeType: SectionSizeType,
        buttonType: [TitleForSectionButtonType]?
    ) { ("", .small, nil) }
    
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

<video width="320" height="140" src = "https://github.com/user-attachments/assets/8f652c61-6440-4757-8431-025c4549274d"> 

## 🧰 Installation
```swift
dependencies: [
    .package(url: "https://github.com/yourusername/GenericCollectionView.git", from: "0.0.2")
]
```

