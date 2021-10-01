//  Copyright (c) 2021 Pedro Almeida
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import SwiftUI
import UIKit

extension UIKitElementLibrary {
    @available(iOS 13.0, *)
    final class UINavigationBarAppearanceInspectableViewModel: InspectorElementViewModelProtocol {

        private enum Property: String, Swift.CaseIterable {
            case information
            case iOS15_behaviorWarning
            case backgroundEffect = "Blur Style"
            case backgroundColor = "Background"
            case backgroundImage = "Image"
            case backgroundImageContentMode = "Content Mode"
            case shadowColor = "Shadow Color"
            case shadowImage = "Shadow Image"
            case separator0
            case titleOffset = "Title Offset"
            case separator1

            case titleGroup = "Title Attributes"
            case titleFontName = "Title Font Name"
            case titleFontSize = "Title Font Size"
            case titleColor = "Title Color"
            case titleShadow = "Title Shadow"
            case titleShadowOffset = "Title Shadow Offset"

            case largeTitleGroup = "Large Title Attributes"
            case largeTitleFontName = "Large Title Font Name"
            case largeTitleFontSize = "Large Title Font Size"
            case largeTitleColor = "Large Title Color"
            case largeTitleShadow = "Large Title Shadow"
            case largeTitleShadowOffset = "Large Title Shadow Offset"
        }

        private enum TitleAttribute: String, Swift.CaseIterable {
            case groupTitle
            case fontName = "Title Font Name"
            case fontSize = "Title Font Size"
            case color = "Title Color"
            case shadow = "Title Shadow"
            case shadowOffset = "Shadow Offset"
        }
        enum `Type`: CustomStringConvertible {
            case standard, compact, scrollEdge, compactScrollEdge

            var description: String {
                switch self {
                case .standard:
                    return "Standard"
                case .compact:
                    return "Compact"
                case .scrollEdge:
                    return "Scroll Edge"
                case .compactScrollEdge:
                    return "Compact Scroll Edge"
                }
            }

            var message: String {
                switch self {
                case .standard:
                    return "The appearance settings for a standard-height navigation bar."
                case .compact:
                    return "The appearance settings for a compact-height navigation bar."
                case .scrollEdge:
                    return "The appearance settings for the navigation bar when content is scrolled to the top."
                case .compactScrollEdge:
                    return "The appearance settings for a compact-height navigation bar when content is scrolled to the top."
                }
            }

            var properties: [InspectorElementViewModelProperty] {
                var array: [InspectorElementViewModelProperty] = []

                array.append(.infoNote(icon: .info, text: message))

                if #available(iOS 15.0, *) {
                    switch self {
                    case .scrollEdge:
                        array.append(
                            .infoNote(
                                icon: .warning,
                                text: "Starting iOS 15 when this property is nil, the navigation bar's background will become transparent when scrolled to the top."
                            )
                        )
                    case .compactScrollEdge:
                        array.append(
                            .infoNote(
                                icon: .warning,
                                text: "Starting iOS 15 when this property is nil, the navigation bar's background will become transparent when scrolled to the top in a vertically compact orientation."
                            )
                        )
                    default:
                        break
                    }
                }

                return array
            }
        }

        var title: String {
            type.description.string(appending: "Appearance", separator: " ")
        }

        let type: `Type`

        weak var navigationBar: UINavigationBar?

        var appearance: UINavigationBarAppearance? {
            switch type {
            case .standard:
                return navigationBar?.standardAppearance
            case .compact:
                return navigationBar?.compactAppearance
            case .scrollEdge:
                return navigationBar?.scrollEdgeAppearance
            case .compactScrollEdge:
                #if swift(>=5.5)
                if #available(iOS 15.0, *) {
                    return navigationBar?.compactScrollEdgeAppearance
                }
                #endif
                return nil
            }
        }

        init?(type: Type, view: UIView) {
            guard let navigationBar = view as? UINavigationBar else { return nil }

            self.type = type
            self.navigationBar = navigationBar
        }

        var properties: [InspectorElementViewModelProperty] {
            if let appearance = appearance {
                return makeProperties(for: appearance)
            }

            return type.properties
        }

        private func makeProperties(for appearance: UINavigationBarAppearance) -> [InspectorElementViewModelProperty] {
            Property.allCases.compactMap { property in
                switch property {
                case .information:
                    return type.properties.first

                case .iOS15_behaviorWarning:
                    return type.properties.last
                    
                case .backgroundEffect:
                    return .optionsList(
                        title: property.rawValue,
                        emptyTitle: "None",
                        options: UIBlurEffect.Style.allCases.map { $0.description },
                        selectedIndex: {
                            guard let style = appearance.backgroundEffect?.style else { return nil }
                            return UIBlurEffect.Style.allCases.firstIndex(of: style)
                        },
                        handler: {
                            if let newIndex = $0,
                               (0 ..< UIBlurEffect.Style.allCases.count).contains(newIndex)
                            {
                                let backgroundStyle = UIBlurEffect.Style.allCases[newIndex]
                                appearance.backgroundEffect = UIBlurEffect(style: backgroundStyle)
                            }
                            else { appearance.backgroundEffect = .none }
                        }
                    )

                case .backgroundColor:
                    return
                        .colorPicker(
                            title: property.rawValue,
                            emptyTitle: Texts.default,
                            color: { appearance.backgroundColor },
                            handler: { appearance.backgroundColor = $0 }
                        )

                case .backgroundImage:
                    return
                        .imagePicker(
                            title: property.rawValue,
                            image: { appearance.backgroundImage },
                            handler: { appearance.backgroundImage = $0 }
                        )

                case .backgroundImageContentMode:
                    return
                        .optionsList(
                            title: property.rawValue,
                            options: UIView.ContentMode.allCases.map(\.description),
                            selectedIndex: { UIView.ContentMode.allCases.firstIndex(of: appearance.backgroundImageContentMode) }
                        ) {
                            guard let newIndex = $0 else { return }
                            let backgroundImageContentMode = UIView.ContentMode.allCases[newIndex]
                            appearance.backgroundImageContentMode = backgroundImageContentMode
                        }

                case .shadowColor:
                    return
                        .colorPicker(
                            title: property.rawValue,
                            emptyTitle: Texts.default,
                            color: { appearance.shadowColor },
                            handler: { appearance.shadowColor = $0 }
                        )

                case .shadowImage:
                    return
                        .imagePicker(
                            title: property.rawValue,
                            image: { appearance.shadowImage },
                            handler: { appearance.shadowImage = $0 }
                        )

                case .separator0, .separator1:
                    return .separator

                case .titleOffset:
                    return nil

                case .titleGroup,
                     .largeTitleGroup:
                    return .group(title: property.rawValue)

                case .titleFontName:
                    return .fontNamePicker(
                        title: property.rawValue,
                        fontProvider: { appearance.titleTextAttributes[.font] as? UIFont },
                        handler: { appearance.titleTextAttributes[.font] = $0 }
                    )
                case .titleFontSize:
                    return .fontSizeStepper(
                        title: property.rawValue,
                        fontProvider: { appearance.titleTextAttributes[.font] as? UIFont },
                        handler: { appearance.titleTextAttributes[.font] = $0 }
                    )
                case .titleColor:
                    return .colorPicker(
                        title: property.rawValue,
                        emptyTitle: Texts.default,
                        color: { appearance.titleTextAttributes[.foregroundColor] as? UIColor },
                        handler: { appearance.titleTextAttributes[.foregroundColor] = $0 }
                    )
                case .titleShadow:
                    return .colorPicker(
                        title: property.rawValue,
                        emptyTitle: Texts.default,
                        color: { (appearance.titleTextAttributes[.shadow] as? NSShadow)?.shadowColor as? UIColor },
                        handler: { (appearance.titleTextAttributes[.shadow] as? NSShadow)?.shadowColor = $0 }
                    )
                case .titleShadowOffset:
                    return .cgSize(
                        title: property.rawValue,
                        size: { (appearance.titleTextAttributes[.shadow] as? NSShadow)?.shadowOffset ?? .zero },
                        handler: { (appearance.titleTextAttributes[.shadow] as? NSShadow)?.shadowOffset = $0 ?? .zero }
                    )

                case .largeTitleFontName:
                    return .fontNamePicker(
                        title: property.rawValue,
                        fontProvider: { appearance.largeTitleTextAttributes[.font] as? UIFont },
                        handler: { appearance.largeTitleTextAttributes[.font] = $0 }
                    )
                case .largeTitleFontSize:
                    return .fontSizeStepper(
                        title: property.rawValue,
                        fontProvider: { appearance.largeTitleTextAttributes[.font] as? UIFont },
                        handler: { appearance.largeTitleTextAttributes[.font] = $0 }
                    )
                case .largeTitleColor:
                    return .colorPicker(
                        title: property.rawValue,
                        emptyTitle: Texts.default,
                        color: { appearance.largeTitleTextAttributes[.foregroundColor] as? UIColor },
                        handler: { appearance.largeTitleTextAttributes[.foregroundColor] = $0 }
                    )
                case .largeTitleShadow:
                    return .colorPicker(
                        title: property.rawValue,
                        emptyTitle: Texts.default,
                        color: { (appearance.titleTextAttributes[.shadow] as? NSShadow)?.shadowColor as? UIColor },
                        handler: { (appearance.titleTextAttributes[.shadow] as? NSShadow)?.shadowColor = $0 }
                    )
                case .largeTitleShadowOffset:
                    return .cgSize(
                        title: property.rawValue,
                        size: { (appearance.titleTextAttributes[.shadow] as? NSShadow)?.shadowOffset ?? .zero },
                        handler: { (appearance.titleTextAttributes[.shadow] as? NSShadow)?.shadowOffset = $0 ?? .zero }
                    )
                }
            }
        }
    }
}

@available(iOS 13.0, *)
extension UIBlurEffect.Style: CaseIterable {
    typealias AllCases = [UIBlurEffect.Style]

    static let allCases: [UIBlurEffect.Style] = [
        .regular,
        .prominent,

        .systemUltraThinMaterial,
        .systemThinMaterial,
        .systemMaterial,
        .systemThickMaterial,
        .systemChromeMaterial,

        .systemUltraThinMaterialLight,
        .systemThinMaterialLight,
        .systemMaterialLight,
        .systemThickMaterialLight,
        .systemChromeMaterialLight,

        .systemUltraThinMaterialDark,
        .systemThinMaterialDark,
        .systemMaterialDark,
        .systemThickMaterialDark,
        .systemChromeMaterialDark
    ]
}

@available(iOS 13.0, *)
extension UIBlurEffect.Style: CustomStringConvertible {
    var description: String {
        switch self {
        case .extraLight:
            return "Extra Light"
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        case .regular:
            return "Regular"
        case .prominent:
            return "Prominent"
        case .systemUltraThinMaterial:
            return "Ultra Thin Material"
        case .systemThinMaterial:
            return "Thin Material"
        case .systemMaterial:
            return "Material"
        case .systemThickMaterial:
            return "Thick Material"
        case .systemChromeMaterial:
            return "Chrome Material"
        case .systemUltraThinMaterialLight:
            return "Ultra Thin Material Light"
        case .systemThinMaterialLight:
            return "Thin Material Light"
        case .systemMaterialLight:
            return "Material Light"
        case .systemThickMaterialLight:
            return "Thick Material Light"
        case .systemChromeMaterialLight:
            return "Chrome Material Light"
        case .systemUltraThinMaterialDark:
            return "Ultra Thin Material Dark"
        case .systemThinMaterialDark:
            return "Thin Material Dark"
        case .systemMaterialDark:
            return "Material Dark"
        case .systemThickMaterialDark:
            return "Thick Material Dark"
        case .systemChromeMaterialDark:
            return "Chrome Material Dark"
        @unknown default:
            return "Unkown"
        }
    }
}

extension UIBlurEffect {
    var style: Style? {
        let description = self.description

        if description.contains("UIBlurEffectStyleExtraLight") {
            return .extraLight
        }
        if description.contains("UIBlurEffectStyleLight") {
            return .light
        }
        if description.contains("UIBlurEffectStyleDark") {
            return .dark
        }
        if description.contains("UIBlurEffectStyleRegular") {
            return .regular
        }
        if description.contains("UIBlurEffectStyleProminent") {
            return .prominent
        }

        guard #available(iOS 13.0, *) else { return nil }

        if description.contains("UIBlurEffectStyleSystemUltraThinMaterialLight") {
            return .systemUltraThinMaterialLight
        }
        if description.contains("UIBlurEffectStyleSystemThinMaterialLight") {
            return .systemThinMaterialLight
        }
        if description.contains("UIBlurEffectStyleSystemMaterialLight") {
            return .systemMaterialLight
        }
        if description.contains("UIBlurEffectStyleSystemThickMaterialLight") {
            return .systemThickMaterialLight
        }
        if description.contains("UIBlurEffectStyleSystemChromeMaterialLight") {
            return .systemChromeMaterialLight
        }
        if description.contains("UIBlurEffectStyleSystemUltraThinMaterialDark") {
            return .systemUltraThinMaterialDark
        }
        if description.contains("UIBlurEffectStyleSystemThinMaterialDark") {
            return .systemThinMaterialDark
        }
        if description.contains("UIBlurEffectStyleSystemMaterialDark") {
            return .systemMaterialDark
        }
        if description.contains("UIBlurEffectStyleSystemThickMaterialDark") {
            return .systemThickMaterialDark
        }
        if description.contains("UIBlurEffectStyleSystemChromeMaterialDark") {
            return .systemChromeMaterialDark
        }
        if description.contains("UIBlurEffectStyleSystemUltraThinMaterial") {
            return .systemUltraThinMaterial
        }
        if description.contains("UIBlurEffectStyleSystemThinMaterial") {
            return .systemThinMaterial
        }
        if description.contains("UIBlurEffectStyleSystemMaterial") {
            return .systemMaterial
        }
        if description.contains("UIBlurEffectStyleSystemThickMaterial") {
            return .systemThickMaterial
        }
        if description.contains("UIBlurEffectStyleSystemChromeMaterial") {
            return .systemChromeMaterial
        }

        return nil
    }
}
