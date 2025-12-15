//
//  CHeaderView.swift
//  GenericCollectionViewKit
//
//  Created by Engin Gülek on 11.11.2025.
//

import UIKit

public final class CHeaderView: UICollectionReusableView {
    
    // MARK: - Title Label
    /* A UILabel used to display the title of the section header.
     It is styled with bold font and truncated if too long.*/
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .boldSystemFont(ofSize: 20)
        lbl.lineBreakMode = .byTruncatingTail
        lbl.numberOfLines = 1
        lbl.adjustsFontSizeToFitWidth = false
        lbl.setContentHuggingPriority(.defaultLow, for: .horizontal)
        lbl.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return lbl
    }()
    
    // MARK: - Title Icon
    /* A UIImageView used to display an optional iconnext to the section header title.
     Supports both system images and asset-based images.Hidden by default when no icon is provided. */
    private lazy var titleIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    // MARK: - Button and Stack References
    /* Variables to hold the stack views and button callback.
     buttonTypes keeps track of the available buttons.*/
    private var buttonStack: UIStackView?
    private var mainStack: UIStackView?
    private var onTap: ((TitleForSectionButtonType) -> Void)?
    private var buttonTypes: [TitleForSectionButtonType] = []
    
    // MARK: - Initializer
    /* Standard initializer for UICollectionReusableView.
     Calls setupUI to configure initial view properties.*/
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    /* Sets the initial background color and other visual properties for the header view.*/
    private func setupUI() {
        backgroundColor = .clear
    }
    
    // MARK: - Button Action
    /* Called when a button in the header is tapped.
     Executes the callback with the corresponding button model.*/
   
    @objc private func buttonTapped(_ sender: UIButton) {
        let index = sender.tag
        guard index < buttonTypes.count else { return }
        let buttonModel = buttonTypes[index]
        onTap?(buttonModel)
    }
}

// MARK: - Configuration
extension CHeaderView {
    /* Configures the header view with title, optional buttons, and tap callback.
     Dynamically creates stack views and separators.*/
    public func configure(
        with item: HeaderViewItem,
        onTap: @escaping (TitleForSectionButtonType) -> Void
    ) {
        self.onTap = onTap
        titleLabel.text = item.title
        titleLabel.font = .boldSystemFont(ofSize: item.sizeType.size)
        
        if let icon = item.icon {
            switch icon.image {
            case .systemImage(let name):
                titleIcon.image = UIImage(systemName: name)
            case .imageAsstes(let name):
                titleIcon.image = UIImage(named: name)
            }
            titleIcon.tintColor = icon.tintColor.uiColor
            titleIcon.isHidden = false
        } else {
            titleIcon.isHidden = true
        }
        
        //Determine if the header should be visible based on title and buttons.
        let hasTitle = !(item.title.isEmpty)
        let hasButtons = !(item.buttonTypes.isEmpty)
        let shouldShowHeader = hasTitle || hasButtons
        
        if !shouldShowHeader {
            isHidden = true
            return
        } else {
            isHidden = false
        }

        mainStack?.removeFromSuperview()
        
        // Create horizontal stack for buttons with spacing and proportional distribution.
        let buttonStack = UIStackView()
        buttonStack.axis = .horizontal
        buttonStack.alignment = .center
        buttonStack.spacing = 3
        buttonStack.distribution = .fillProportionally
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Single separator example
        let separator = UIView()
        separator.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        // Create buttons and separators for each type in cellItem.buttonTypes
        
        if  !item.buttonTypes.isEmpty {
            let types = item.buttonTypes
            self.buttonTypes = types
            for (index, model) in types.enumerated() {
                let separator = UIView()
                separator.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
                separator.translatesAutoresizingMaskIntoConstraints = false
                separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
                separator.heightAnchor.constraint(equalToConstant: 18).isActive = true
                
                let button = UIButton(type: .custom)
                button.setTitle(model.title, for: .normal)
                button.setTitleColor(item.buttonColor.uiColor, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
                button.tag = index
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                buttonStack.addArrangedSubview(separator)
                buttonStack.addArrangedSubview(button)
                buttonStack.addArrangedSubview(separator)
            }
        }
        
        self.buttonStack = buttonStack
        
        //  Main stack contains the icon title label and button stack, horizontally aligned.
        let mainStack = UIStackView(arrangedSubviews: [titleIcon,titleLabel, buttonStack])
        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.spacing = 8
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainStack)
        self.mainStack = mainStack
        
        // Pin main stack to the edges of the header with some padding.
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            mainStack.topAnchor.constraint(equalTo: topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        
        NSLayoutConstraint.activate([
            titleIcon.heightAnchor.constraint(equalToConstant: 20),
            titleIcon.widthAnchor.constraint(equalToConstant: 20)
           
        ])
        
        // Set content hugging and compression priorities to ensure proper layout behavior.
        buttonStack.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
}
