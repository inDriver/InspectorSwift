//
//  HiearchyInspectableElementProperty+Stepper.swift
//  HierarchyInspector
//
//  Created by Pedro Almeida on 06.12.20.
//

import UIKit

public extension HiearchyInspectableElementProperty {
    
    static func integerStepper(
        title: String,
        value: @escaping IntProvider,
        range: @escaping IntClosedRangeProvider,
        stepValue: @escaping IntProvider,
        handler: IntHandler?
    ) -> HiearchyInspectableElementProperty {
        .stepper(
            title: title,
            value: { Double(value()) },
            range: { Double(range().lowerBound)...Double(range().upperBound) },
            stepValue: { Double(stepValue()) },
            isDecimalValue: false
        ) { doubleValue in
            handler?(Int(doubleValue))
        }
    }
    
    static func cgFloatStepper(
        title: String,
        value: @escaping CGFloatProvider,
        range: @escaping CGFloatClosedRangeProvider,
        stepValue: @escaping CGFloatProvider,
        handler: CGFloatHandler?
    ) -> HiearchyInspectableElementProperty {
        .stepper(
            title: title,
            value: { Double(value()) },
            range: { Double(range().lowerBound)...Double(range().upperBound) },
            stepValue: { Double(stepValue()) },
            isDecimalValue: true
        ) { doubleValue in
            handler?(CGFloat(doubleValue))
        }
    }
    
    static func floatStepper(
        title: String,
        value: @escaping (() -> Float),
        range: @escaping (() -> ClosedRange<Float>),
        stepValue: @escaping (() -> Float),
        handler: ((Float) -> Void)?
    ) -> HiearchyInspectableElementProperty {
        .stepper(
            title: title,
            value: { Double(value()) },
            range: { Double(range().lowerBound)...Double(range().upperBound)} ,
            stepValue: { Double(stepValue()) },
            isDecimalValue: true
        ) { doubleValue in
            handler?(Float(doubleValue))
        }
    }
    
}
