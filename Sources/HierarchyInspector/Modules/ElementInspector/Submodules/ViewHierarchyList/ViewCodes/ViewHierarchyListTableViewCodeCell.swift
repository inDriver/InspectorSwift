//
//  ViewHierarchyListTableViewCodeCell.swift
//  HierarchyInspector
//
//  Created by Pedro Almeida on 07.10.20.
//

import UIKit

final class ViewHierarchyListTableViewCodeCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var viewModel: ViewHierarchyListItemViewModelProtocol? {
        didSet {
            
            // Name
            
            elementNameLabel.text = viewModel?.title

            elementNameLabel.font = viewModel?.titleFont
            
            thumbnailImageView.image = viewModel?.thumbnailImage
            
            accessoryType = viewModel?.showDisclosureIndicator == true ? .detailDisclosureButton : .detailButton

            // Collapsed

            isCollapsed = viewModel?.isCollapsed == true
            
            chevronDownIcon.isSafelyHidden = viewModel?.isContainer != true || viewModel?.showDisclosureIndicator == true

            // Description

            descriptionLabel.text = viewModel?.subtitle

            // Containers Insets

            let offset = ElementInspector.configuration.appearance.horizontalMargins * (CGFloat(viewModel?.relativeDepth ?? 0) + 1)

            separatorInset = UIEdgeInsets(top: 0, left: offset, bottom: 0, right: 0)
            directionalLayoutMargins = .margins(leading: offset)
            containerStackView.directionalLayoutMargins = directionalLayoutMargins
        }
    }
    
    var isEvenRow = false {
        didSet {
            switch isEvenRow {
            case true:
                backgroundColor = ElementInspector.configuration.appearance.panelBackgroundColor
                
            case false:
                backgroundColor = ElementInspector.configuration.appearance.panelHighlightBackgroundColor
            }
        }
    }
    
    var isCollapsed = false {
        didSet {
            chevronDownIcon.transform = isCollapsed ? .init(rotationAngle: -(.pi / 2)) : .identity
        }
    }
    
    func toggleCollapse(animated: Bool) {
        guard animated else {
            isCollapsed.toggle()
            return
        }
        
        UIView.animate(
            withDuration: ElementInspector.configuration.animationDuration,
            delay: 0,
            options: [.beginFromCurrentState, .curveEaseInOut],
            animations: { [weak self] in
                
                self?.isCollapsed.toggle()
                
            },
            completion: nil
        )
    }
    
    private lazy var elementNameLabel = UILabel().then {
        $0.layer.shouldRasterize = true
        $0.layer.rasterizationScale = UIScreen.main.scale
        
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
        $0.numberOfLines = 0
        $0.adjustsFontSizeToFitWidth = true
        $0.preferredMaxLayoutWidth = 200
    }
    
    private lazy var descriptionLabel = UILabel(
        .caption2,
        textColor: ElementInspector.configuration.appearance.secondaryTextColor,
        numberOfLines: 0
    ).then {
        $0.layer.shouldRasterize = true
        $0.layer.rasterizationScale = UIScreen.main.scale
        
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
        $0.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        $0.preferredMaxLayoutWidth = 200
    }
    
    private lazy var chevronDownIcon = Icon.chevronDownIcon()
    
    private lazy var thumbnailImageView = UIImageView().then {
        $0.contentMode = .center
        $0.tintColor   = ElementInspector.configuration.appearance.thumbnailBackgroundStyle.contrastingColor
    }
        
    private lazy var thumbnailContainerView = UIImageView(image: IconKit.imageOfColorGrid().resizableImage(withCapInsets: .zero)).then {
        $0.installView(thumbnailImageView, .centerXY)
        
        $0.layer.shouldRasterize = true
        
        $0.layer.rasterizationScale = UIScreen.main.scale
        
        $0.backgroundColor = ElementInspector.configuration.appearance.thumbnailBackgroundStyle.color
        
        $0.clipsToBounds = true
        
        $0.layer.cornerRadius = ElementInspector.configuration.appearance.verticalMargins
        
        $0.heightAnchor.constraint(equalToConstant: ElementInspector.configuration.appearance.horizontalMargins * 2).isActive = true
        
        $0.widthAnchor.constraint(equalToConstant: ElementInspector.configuration.appearance.horizontalMargins * 2.5).isActive = true
    }
    
    private lazy var containerStackView = UIStackView(
        axis: .vertical,
        arrangedSubviews: [
            elementNameLabel,
            textStackView
        ],
        spacing: ElementInspector.configuration.appearance.verticalMargins / 2
    )
    
    private lazy var textStackView = UIStackView(
        axis: .horizontal,
        arrangedSubviews: [
            thumbnailContainerView,
            descriptionLabel
        ],
        spacing: ElementInspector.configuration.appearance.verticalMargins / 2
    ).then {
        $0.alignment = .top
    }
    
    private lazy var customSelectedBackgroundView = UIView().then {
        $0.backgroundColor = ElementInspector.configuration.appearance.tintColor.withAlphaComponent(0.1)
    }
    
    private func setup() {
        setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        isOpaque = true
        
        contentView.isUserInteractionEnabled = false
        
        contentView.clipsToBounds = true
        
        selectedBackgroundView = customSelectedBackgroundView
        
        backgroundColor = ElementInspector.configuration.appearance.panelBackgroundColor
        
        setupContainerStackView()
        
        setupChevronDownIcon()
    }
    
    private func setupContainerStackView() {
        contentView.installView(
            containerStackView,
            .margins(
                top: ElementInspector.configuration.appearance.verticalMargins,
                leading: 0,
                bottom: ElementInspector.configuration.appearance.verticalMargins,
                trailing: ElementInspector.configuration.appearance.verticalMargins
            )
        )
    }
    
    private func setupChevronDownIcon() {
        contentView.addSubview(chevronDownIcon)
        
        chevronDownIcon.centerYAnchor.constraint(equalTo: elementNameLabel.centerYAnchor).isActive = true

        chevronDownIcon.trailingAnchor.constraint(
            equalTo: elementNameLabel.leadingAnchor,
            constant: -(ElementInspector.configuration.appearance.verticalMargins / 3)
        ).isActive = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        viewModel = nil
        
        thumbnailImageView.image = nil
    }
    
}
