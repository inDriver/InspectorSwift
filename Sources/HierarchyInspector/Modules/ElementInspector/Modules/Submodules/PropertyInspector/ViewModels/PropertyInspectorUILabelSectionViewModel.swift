//
//  PropertyInspectorUILabelSectionViewModel.swift
//  HierarchyInspector
//
//  Created by Pedro Almeida on 10.10.20.
//

import UIKit

final class PropertyInspectorUILabelSectionViewModel: PropertyInspectorSectionViewModelProtocol {
    
    enum Property: CaseIterable {
        case text
        case color
        case fontName
        case fontSize
        case adjustsFontSizeToFitWidth
        case textAlignment
        case numberOfLines
        case groupBehavior
        case isEnabled
        case isHighlighted
        case separator0
        case baseline
        case lineBreak
        case autoShrink
        case allowsDefaultTighteningForTruncation
        case separator1
        case highlightedTextColor
        case shadowColor
    }
    
    private(set) weak var label: UILabel?
    
    init(label: UILabel) {
        self.label = label
    }
    
    private(set) lazy var title: String? = "Label"
    
    private(set) lazy var propertyInpus: [PropertyInspectorInput] = Property.allCases.compactMap {
        guard let label = label else {
            return nil
        }

        switch $0 {
        
        case .text:
            return .textInput(
                title: "text",
                value: label.text,
                placeholder: label.text ?? "text"
            ) { text in
                label.text = text
            }
            
        case .color:
            return .colorPicker(
                title: "text color",
                color: label.textColor
            ) { textColor in
                label.textColor = textColor
            }
            
        case .fontName:
            return .fontNamePicker(
                fontProvider: { label.font }
            ) { font in
                guard let font = font else {
                    return
                }
                
                label.font = font
            }
            
        case .fontSize:
            return .fontSizeStepper(
                fontProvider: { label.font }
            ) { font in
                guard let font = font else {
                    return
                }
                
                label.font = font
            }
            
        case .adjustsFontSizeToFitWidth:
            return .toggleButton(
                title: "automatically adjusts font",
                isOn: label.adjustsFontSizeToFitWidth
            ) { adjustsFontSizeToFitWidth in
                label.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
            }
            
        case .textAlignment:
            return .inlineImageOptions(
                title: "alignment",
                images: NSTextAlignment.allCases.map { $0.image },
                selectedSegmentIndex: NSTextAlignment.allCases.firstIndex(of: label.textAlignment)
            ) {
                guard let newIndex = $0 else {
                    return
                }
                
                let textAlignment = NSTextAlignment.allCases[newIndex]
                
                label.textAlignment = textAlignment
            }
            
        case .numberOfLines:
            return .integerStepper(
                title: "lines",
                value: label.numberOfLines,
                range: 0...100,
                stepValue: 1
            ) { numberOfLines in
                label.numberOfLines = numberOfLines
            }
            
        case .groupBehavior:
            return .subSection(name: "behavior")
            
        case .isEnabled:
            return .toggleButton(
                title: "enabled",
                isOn: label.isEnabled
            ) { isEnabled in
                label.isEnabled = isEnabled
            }
        
        case .isHighlighted:
            return .toggleButton(
                title: "highlighted",
                isOn: label.isHighlighted
            ) { isHighlighted in
                label.isHighlighted = isHighlighted
            }
            
        case .separator0,
             .separator1:
            return .separator
            
        case .baseline:
            return nil
            
        case .lineBreak:
            return nil
            
        case .autoShrink:
            return nil
            
        case .allowsDefaultTighteningForTruncation:
            return .toggleButton(
                title: "tighten letter spacing",
                isOn: label.allowsDefaultTighteningForTruncation
            ) { allowsDefaultTighteningForTruncation in
                label.allowsDefaultTighteningForTruncation = allowsDefaultTighteningForTruncation
            }
            
        case .highlightedTextColor:
            return .colorPicker(
                title: "highlighted color",
                color: label.highlightedTextColor
            ) { highlightedTextColor in
                label.highlightedTextColor = highlightedTextColor
            }
            
        case .shadowColor:
            return .colorPicker(
                title: "shadow",
                color: label.shadowColor
            ) { shadowColor in
                label.shadowColor = shadowColor
            }
            
        }
        
    }
}

extension NSTextAlignment: CaseIterable {
    public typealias AllCases = [NSTextAlignment]
    
    public static let allCases: [NSTextAlignment] = [
        .left,
        .center,
        .right,
        .justified,
        .natural
    ]
}

extension NSTextAlignment {
    var image: UIImage {
        switch self {
        case .left:
            return IconKit.imageOfTextAlignmentLeft()
            
        case .center:
            return IconKit.imageOfTextAlignmentCenter()
            
        case .right:
            return IconKit.imageOfTextAlignmentRight()
            
        case .justified:
            return IconKit.imageOfTextAlignmentJustified()
            
        case .natural:
            return IconKit.imageOfTextAlignmentNatural()
            
        @unknown default:
            return UIImage()
        }
    }
}
