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

import UIKit

extension NSObject {
    static let denyListPropertyNames = [
        "UINavigationBar._contentViewHidden",
        "UITextView.PINEntrySeparatorIndexes",
        "UITextView.acceptsDictationSearchResults",
        "UITextView.acceptsEmoji",
        "UITextView.acceptsFloatingKeyboard",
        "UITextView.acceptsInitialEmojiKeyboard",
        "UITextView.acceptsPayloads",
        "UITextView.acceptsSplitKeyboard",
        "UITextView.autocapitalizationType",
        "UITextView.autocorrectionContext",
        "UITextView.autocorrectionType",
        "UITextView.contentsIsSingleValue",
        "UITextView.deferBecomingResponder",
        "UITextView.disableHandwritingKeyboard",
        "UITextView.disableInputBars",
        "UITextView.disablePrediction",
        "UITextView.displaySecureEditsUsingPlainText",
        "UITextView.displaySecureTextUsingPlainText",
        "UITextView.emptyContentReturnKeyType",
        "UITextView.enablesReturnKeyAutomatically",
        "UITextView.enablesReturnKeyOnNonWhiteSpaceContent",
        "UITextView.floatingKeyboardEdgeInsets",
        "UITextView.forceDefaultDictationInfo",
        "UITextView.forceDictationKeyboardType",
        "UITextView.forceFloatingKeyboard",
        "UITextView.hasDefaultContents",
        "UITextView.hidePrediction",
        "UITextView.inputContextHistory",
        "UITextView.insertionPointColor",
        "UITextView.insertionPointWidth",
        "UITextView.isCarPlayIdiom",
        "UITextView.isSingleLineDocument",
        "UITextView.keyboardAppearance",
        "UITextView.keyboardType",
        "UITextView.learnsCorrections",
        "UITextView.loadKeyboardsForSiriLanguage",
        "UITextView.passwordRules",
        "UITextView.preferOnlineDictation",
        "UITextView.preferredKeyboardStyle",
        "UITextView.recentInputIdentifier",
        "UITextView.responseContext",
        "UITextView.returnKeyGoesToNextResponder",
        "UITextView.returnKeyType",
        "UITextView.selectionBarColor",
        "UITextView.selectionBorderColor",
        "UITextView.selectionBorderWidth",
        "UITextView.selectionCornerRadius",
        "UITextView.selectionDragDotImage",
        "UITextView.selectionEdgeInsets",
        "UITextView.selectionHighlightColor",
        "UITextView.shortcutConversionType",
        "UITextView.showDictationButton",
        "UITextView.smartDashesType",
        "UITextView.smartInsertDeleteType",
        "UITextView.smartQuotesType",
        "UITextView.spellCheckingType",
        "UITextView.supplementalLexicon",
        "UITextView.supplementalLexiconAmbiguousItemIcon",
        "UITextView.suppressReturnKeyStyling",
        "UITextView.textContentType",
        "UITextView.textLoupeVisibility",
        "UITextView.textScriptType",
        "UITextView.textSelectionBehavior",
        "UITextView.textSuggestionDelegate",
        "UITextView.textTrimmingSet",
        "UITextView.underlineColorForSpelling",
        "UITextView.underlineColorForTextAlternatives",
        "UITextView.useAutomaticEndpointing",
        "UITextView.useInterfaceLanguageForLocalization",
        "UITextView.validTextRange",
        "UITextField.textTrimmingSet",
        "WKContentView._wk_printedDocument",
        "WKWebView._wk_printedDocument"
    ]

    func propertyNames() -> [String] {
        var propertyCount: UInt32 = 0
        var propertyNames: [String] = []

        guard
            let propertyListPointer = class_copyPropertyList(type(of: self), &propertyCount),
            propertyCount > .zero
        else {
            return []
        }

        for index in 0 ..< Int(propertyCount) {
            let pointer = propertyListPointer[index]

            guard let propertyName = NSString(utf8String: property_getName(pointer)) as String?
            else { continue }

            propertyNames.append(propertyName)
        }

        free(propertyListPointer)
        return propertyNames
    }

    func safeValue(forKey key: String) -> Any? {
        let fullName = "\(_classNameWithoutQualifiers).\(key)"

        if Self.denyListPropertyNames.contains(fullName) {
            return nil
        }
        return value(forKey: key)
    }
}

final class RuntimeAttributesAttributesViewModel: InspectorElementViewModelProtocol {
    let title = "Runtime Attributes"

    private(set) weak var view: UIView?

    let propertyNames: [String]

    let hideUknownValues: Bool = true

    init?(view: UIView) {
        let properties = view.propertyNames()

        if properties.isEmpty { return nil }

        self.view = view
        propertyNames = properties
    }

    var properties: [InspectorElementViewModelProperty] {
        guard let view = view else { return [] }

        return propertyNames.compactMap { property in
            guard
                view.responds(to: Selector(property)),
                let result = view.safeValue(forKey: property)
            else {
                if hideUknownValues {
                    return nil
                }
                return .textField(
                    title: property,
                    placeholder: "None",
                    axis: .horizontal,
                    value: { nil },
                    handler: nil
                )
            }

            switch result {
            case let boolValue as Bool:
                return .switch(
                    title: property,
                    isOn: { boolValue },
                    handler: nil
                )
            case let colorValue as UIColor:
                return .colorPicker(
                    title: property,
                    color: { colorValue },
                    handler: nil
                )
            case let imageValue as UIImage:
                return .imagePicker(
                    title: property,
                    image: { imageValue },
                    handler: nil
                )
            case let number as NSNumber:
                return .stepper(
                    title: property,
                    value: { number.doubleValue },
                    range: { 0 ... max(1, number.doubleValue) },
                    stepValue: { 1 },
                    isDecimalValue: Double(number.intValue) != number.doubleValue,
                    handler: nil
                )
            case let size as CGSize:
                return .cgSize(
                    title: property,
                    size: { size },
                    handler: nil
                )
            case let point as CGPoint:
                return .cgPoint(
                    title: property,
                    point: { point },
                    handler: nil
                )
            case let insets as NSDirectionalEdgeInsets:
                return .directionalInsets(
                    title: property,
                    insets: { insets },
                    handler: nil
                )
            case let view as UIView:
                return .textView(
                    title: property,
                    placeholder: nil,
                    value: { view.elementDescription },
                    handler: nil
                )
            case let aClass as AnyClass:
                return .textField(
                    title: property,
                    placeholder: nil,
                    axis: .horizontal,
                    value: { String(describing: aClass) },
                    handler: nil
                )
            case let object as NSObject:
                return .textView(
                    title: property,
                    placeholder: nil,
                    value: {
                        [
                            object._className,
                            "", // spacer
                            object.debugDescription
                        ].joined(separator: "\n")

                    }, handler: nil
                )
            case let stringValue as String:
                return .textView(
                    title: property,
                    placeholder: nil,
                    value: { stringValue },
                    handler: nil
                )
            default:
                return nil
            }
        }
    }
}
