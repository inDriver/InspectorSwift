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

import MapKit
import UIKit
import WebKit

enum ElementAttributesLibrary: Swift.CaseIterable, InspectorElementLibraryProtocol {
    case activityIndicator
    case button
    case datePicker
    case imageView
    case label
    case mapView
    case navigationBar
    case segmentedControl
    case slider
    case stackView
    case `switch`
    case tabBar
    case textField
    case textView
    case tableView
    case webView

    // base classes
    case viewController
    case window
    case scrollView
    case control
    case view
    case layer

    // MARK: - InspectorElementLibraryProtocol

    var targetClass: AnyClass {
        switch self {
        case .viewController:
            return UIViewController.self

        case .tableView:
            return UITableView.self

        case .layer:
            return UIView.self

        case .navigationBar:
            return UINavigationBar.self

        case .window:
            return UIWindow.self

        case .activityIndicator:
            return UIActivityIndicatorView.self

        case .button:
            return UIButton.self

        case .control:
            return UIControl.self

        case .datePicker:
            return UIDatePicker.self

        case .imageView:
            return UIImageView.self

        case .label:
            return UILabel.self

        case .mapView:
            return MKMapView.self

        case .scrollView:
            return UIScrollView.self

        case .segmentedControl:
            return UISegmentedControl.self

        case .slider:
            return UISlider.self

        case .switch:
            return UISwitch.self

        case .stackView:
            return UIStackView.self

        case .textField:
            return UITextField.self

        case .textView:
            return UITextView.self

        case .view:
            return UIView.self

        case .webView:
            return WKWebView.self

        case .tabBar:
            return UITabBar.self
        }
    }

    func sections(for object: NSObject) -> InspectorElementSections {
        switch self {
        case .viewController:
            return .empty

        case .tableView:
            return .init(with: TableViewAttributesSectionDataSource(with: object))

        case .layer:
            return .init(with: LayerAttributesSectionDataSource(with: object))

        case .window:
            return .init(with: WindowAttributesSectionDataSource(with: object))

        case .navigationBar:
            var section = InspectorElementSection()

            if #available(iOS 13.0, *) {
                section.append(NavigationBarAppearanceAttributesSectionDataSource(with: object, type: .standard))
                section.append(NavigationBarAppearanceAttributesSectionDataSource(with: object, type: .compact))
                section.append(NavigationBarAppearanceAttributesSectionDataSource(with: object, type: .scrollEdge))
            }

            if #available(iOS 15.0, *) {
                section.append(NavigationBarAppearanceAttributesSectionDataSource(with: object, type: .compactScrollEdge))
            }

            section.append(NavigationBarAttributesSectionDataSource(with: object))

            return [section]

        case .activityIndicator:
            return .init(with: ActivityIndicatorViewAttributesSectionDataSource(with: object))

        case .button:
            return .init(with: ButtonAttributesSectionDataSource(with: object))

        case .control:
            return .init(with: ControlAttributesSectionDataSource(with: object))

        case .datePicker:
            return .init(with: DatePickerAttributesSectionDataSource(with: object))

        case .imageView:
            return .init(with: ImageViewAttributesSectionDataSource(with: object))

        case .label:
            return .init(with: LabelAttributesSectionDataSource(with: object))

        case .mapView:
            return .init(with: MapViewAttributesSectionDataSource(with: object))

        case .scrollView:
            return .init(with: ScrollViewAttributesSectionDataSource(with: object))

        case .segmentedControl:
            return .init(with: SegmentedControlAttributesSectionDataSource(with: object))

        case .slider:
            return .init(with: SliderAttributesSectionDataSource(with: object))

        case .switch:
            return .init(with: SwitchAttributesSectionDataSource(with: object))

        case .stackView:
            return .init(with: StackViewAttributesSectionDataSource(with: object))

        case .textField:
            return .init(with: TextFieldAttributesSectionDataSource(with: object))

        case .textView:
            return .init(with: TextViewAttributesSectionDataSource(with: object))

        case .view:
            return .init(with: ViewAttributesSectionDataSource(with: object))

        case .tabBar:
            return .init(with: TabBarAttributesSectionDataSource(with: object))

        case .webView:
            return []
        }
    }
}
