//
//  IconKit.swift
//  HierarchyInspector
//
//  Created by Pedro Almeida on Oct 9, 2020.
//
//  Generated by PaintCode Plugin for Sketch
//  http://www.paintcodeapp.com/sketch
//

import UIKit

class IconKit: NSObject {
    
    
    //MARK: - Canvas Drawings
    
    /// Symbols
    
    class func drawSliderHorizontal(color: UIColor, frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 16, height: 16), resizing: ResizingBehavior = .aspectFit) {
        /// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        /// Resize to Target Frame
        context.saveGState()
        let resizedFrame = resizing.apply(rect: CGRect(x: 0, y: 0, width: 16, height: 16), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 16, y: resizedFrame.height / 16)
        
        /// Shape
        let shape = UIBezierPath()
        shape.move(to: CGPoint(x: 8.1, y: 2.99))
        shape.addCurve(to: CGPoint(x: 9.5, y: 2.09), controlPoint1: CGPoint(x: 8.72, y: 2.99), controlPoint2: CGPoint(x: 9.26, y: 2.62))
        shape.addLine(to: CGPoint(x: 11.42, y: 2.09))
        shape.addCurve(to: CGPoint(x: 12, y: 1.49), controlPoint1: CGPoint(x: 11.74, y: 2.09), controlPoint2: CGPoint(x: 12, y: 1.82))
        shape.addCurve(to: CGPoint(x: 11.42, y: 0.9), controlPoint1: CGPoint(x: 12, y: 1.16), controlPoint2: CGPoint(x: 11.74, y: 0.9))
        shape.addLine(to: CGPoint(x: 9.5, y: 0.9))
        shape.addCurve(to: CGPoint(x: 8.1, y: 0), controlPoint1: CGPoint(x: 9.26, y: 0.37), controlPoint2: CGPoint(x: 8.72, y: 0))
        shape.addCurve(to: CGPoint(x: 6.68, y: 0.9), controlPoint1: CGPoint(x: 7.46, y: 0), controlPoint2: CGPoint(x: 6.92, y: 0.37))
        shape.addLine(to: CGPoint(x: 0.6, y: 0.9))
        shape.addCurve(to: CGPoint(x: 0, y: 1.49), controlPoint1: CGPoint(x: 0.26, y: 0.9), controlPoint2: CGPoint(x: 0, y: 1.17))
        shape.addCurve(to: CGPoint(x: 0.6, y: 2.09), controlPoint1: CGPoint(x: 0, y: 1.82), controlPoint2: CGPoint(x: 0.26, y: 2.09))
        shape.addLine(to: CGPoint(x: 6.68, y: 2.09))
        shape.addCurve(to: CGPoint(x: 8.1, y: 2.99), controlPoint1: CGPoint(x: 6.93, y: 2.62), controlPoint2: CGPoint(x: 7.46, y: 2.99))
        shape.close()
        shape.move(to: CGPoint(x: 8.1, y: 2.17))
        shape.addCurve(to: CGPoint(x: 7.4, y: 1.49), controlPoint1: CGPoint(x: 7.71, y: 2.17), controlPoint2: CGPoint(x: 7.4, y: 1.87))
        shape.addCurve(to: CGPoint(x: 8.1, y: 0.82), controlPoint1: CGPoint(x: 7.4, y: 1.11), controlPoint2: CGPoint(x: 7.71, y: 0.82))
        shape.addCurve(to: CGPoint(x: 8.79, y: 1.49), controlPoint1: CGPoint(x: 8.49, y: 0.82), controlPoint2: CGPoint(x: 8.79, y: 1.11))
        shape.addCurve(to: CGPoint(x: 8.1, y: 2.17), controlPoint1: CGPoint(x: 8.79, y: 1.87), controlPoint2: CGPoint(x: 8.49, y: 2.17))
        shape.close()
        shape.move(to: CGPoint(x: 0.58, y: 4.41))
        shape.addCurve(to: CGPoint(x: 0, y: 5), controlPoint1: CGPoint(x: 0.26, y: 4.41), controlPoint2: CGPoint(x: 0, y: 4.67))
        shape.addCurve(to: CGPoint(x: 0.58, y: 5.59), controlPoint1: CGPoint(x: 0, y: 5.33), controlPoint2: CGPoint(x: 0.26, y: 5.59))
        shape.addLine(to: CGPoint(x: 2.52, y: 5.59))
        shape.addCurve(to: CGPoint(x: 3.93, y: 6.5), controlPoint1: CGPoint(x: 2.76, y: 6.12), controlPoint2: CGPoint(x: 3.3, y: 6.5))
        shape.addCurve(to: CGPoint(x: 5.34, y: 5.59), controlPoint1: CGPoint(x: 4.56, y: 6.5), controlPoint2: CGPoint(x: 5.1, y: 6.12))
        shape.addLine(to: CGPoint(x: 11.4, y: 5.59))
        shape.addCurve(to: CGPoint(x: 12, y: 5), controlPoint1: CGPoint(x: 11.74, y: 5.59), controlPoint2: CGPoint(x: 12, y: 5.33))
        shape.addCurve(to: CGPoint(x: 11.4, y: 4.41), controlPoint1: CGPoint(x: 12, y: 4.67), controlPoint2: CGPoint(x: 11.74, y: 4.41))
        shape.addLine(to: CGPoint(x: 5.34, y: 4.41))
        shape.addCurve(to: CGPoint(x: 3.93, y: 3.5), controlPoint1: CGPoint(x: 5.1, y: 3.88), controlPoint2: CGPoint(x: 4.56, y: 3.5))
        shape.addCurve(to: CGPoint(x: 2.52, y: 4.41), controlPoint1: CGPoint(x: 3.3, y: 3.5), controlPoint2: CGPoint(x: 2.76, y: 3.88))
        shape.addLine(to: CGPoint(x: 0.58, y: 4.41))
        shape.close()
        shape.move(to: CGPoint(x: 3.93, y: 5.68))
        shape.addCurve(to: CGPoint(x: 3.24, y: 5), controlPoint1: CGPoint(x: 3.54, y: 5.68), controlPoint2: CGPoint(x: 3.24, y: 5.38))
        shape.addCurve(to: CGPoint(x: 3.93, y: 4.32), controlPoint1: CGPoint(x: 3.24, y: 4.62), controlPoint2: CGPoint(x: 3.54, y: 4.32))
        shape.addCurve(to: CGPoint(x: 4.62, y: 5), controlPoint1: CGPoint(x: 4.32, y: 4.32), controlPoint2: CGPoint(x: 4.62, y: 4.62))
        shape.addCurve(to: CGPoint(x: 3.93, y: 5.68), controlPoint1: CGPoint(x: 4.62, y: 5.38), controlPoint2: CGPoint(x: 4.32, y: 5.68))
        shape.close()
        shape.move(to: CGPoint(x: 8.1, y: 10))
        shape.addCurve(to: CGPoint(x: 9.5, y: 9.1), controlPoint1: CGPoint(x: 8.72, y: 10), controlPoint2: CGPoint(x: 9.26, y: 9.63))
        shape.addLine(to: CGPoint(x: 11.42, y: 9.1))
        shape.addCurve(to: CGPoint(x: 12, y: 8.51), controlPoint1: CGPoint(x: 11.74, y: 9.1), controlPoint2: CGPoint(x: 12, y: 8.83))
        shape.addCurve(to: CGPoint(x: 11.42, y: 7.91), controlPoint1: CGPoint(x: 12, y: 8.18), controlPoint2: CGPoint(x: 11.74, y: 7.91))
        shape.addLine(to: CGPoint(x: 9.5, y: 7.91))
        shape.addCurve(to: CGPoint(x: 8.1, y: 7.01), controlPoint1: CGPoint(x: 9.26, y: 7.38), controlPoint2: CGPoint(x: 8.72, y: 7.01))
        shape.addCurve(to: CGPoint(x: 6.68, y: 7.91), controlPoint1: CGPoint(x: 7.46, y: 7.01), controlPoint2: CGPoint(x: 6.93, y: 7.38))
        shape.addLine(to: CGPoint(x: 0.6, y: 7.91))
        shape.addCurve(to: CGPoint(x: 0, y: 8.51), controlPoint1: CGPoint(x: 0.26, y: 7.91), controlPoint2: CGPoint(x: 0, y: 8.18))
        shape.addCurve(to: CGPoint(x: 0.6, y: 9.1), controlPoint1: CGPoint(x: 0, y: 8.83), controlPoint2: CGPoint(x: 0.26, y: 9.1))
        shape.addLine(to: CGPoint(x: 6.68, y: 9.1))
        shape.addCurve(to: CGPoint(x: 8.1, y: 10), controlPoint1: CGPoint(x: 6.92, y: 9.63), controlPoint2: CGPoint(x: 7.46, y: 10))
        shape.close()
        shape.move(to: CGPoint(x: 8.1, y: 9.18))
        shape.addCurve(to: CGPoint(x: 7.4, y: 8.51), controlPoint1: CGPoint(x: 7.71, y: 9.18), controlPoint2: CGPoint(x: 7.4, y: 8.88))
        shape.addCurve(to: CGPoint(x: 8.1, y: 7.83), controlPoint1: CGPoint(x: 7.4, y: 8.12), controlPoint2: CGPoint(x: 7.71, y: 7.83))
        shape.addCurve(to: CGPoint(x: 8.79, y: 8.51), controlPoint1: CGPoint(x: 8.49, y: 7.83), controlPoint2: CGPoint(x: 8.79, y: 8.12))
        shape.addCurve(to: CGPoint(x: 8.1, y: 9.18), controlPoint1: CGPoint(x: 8.79, y: 8.88), controlPoint2: CGPoint(x: 8.49, y: 9.18))
        shape.close()
        context.saveGState()
        context.translateBy(x: 2, y: 3)
        color.setFill()
        shape.fill()
        context.restoreGState()
        
        context.restoreGState()
    }
    
    class func drawChevronDown(color: UIColor, frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 16, height: 16), resizing: ResizingBehavior = .aspectFit) {
        /// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        /// Resize to Target Frame
        context.saveGState()
        let resizedFrame = resizing.apply(rect: CGRect(x: 0, y: 0, width: 16, height: 16), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 16, y: resizedFrame.height / 16)
        
        /// Path
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 5, y: 6))
        path.addCurve(to: CGPoint(x: 5.55, y: 5.75), controlPoint1: CGPoint(x: 5.21, y: 6), controlPoint2: CGPoint(x: 5.4, y: 5.92))
        path.addLine(to: CGPoint(x: 9.8, y: 1.28))
        path.addCurve(to: CGPoint(x: 10, y: 0.75), controlPoint1: CGPoint(x: 9.93, y: 1.14), controlPoint2: CGPoint(x: 10, y: 0.96))
        path.addCurve(to: CGPoint(x: 9.29, y: 0), controlPoint1: CGPoint(x: 10, y: 0.33), controlPoint2: CGPoint(x: 9.69, y: 0))
        path.addCurve(to: CGPoint(x: 8.77, y: 0.23), controlPoint1: CGPoint(x: 9.1, y: 0), controlPoint2: CGPoint(x: 8.91, y: 0.09))
        path.addLine(to: CGPoint(x: 5, y: 4.21))
        path.addLine(to: CGPoint(x: 1.23, y: 0.23))
        path.addCurve(to: CGPoint(x: 0.71, y: 0), controlPoint1: CGPoint(x: 1.09, y: 0.09), controlPoint2: CGPoint(x: 0.91, y: 0))
        path.addCurve(to: CGPoint(x: 0, y: 0.75), controlPoint1: CGPoint(x: 0.31, y: 0), controlPoint2: CGPoint(x: 0, y: 0.33))
        path.addCurve(to: CGPoint(x: 0.2, y: 1.28), controlPoint1: CGPoint(x: 0, y: 0.96), controlPoint2: CGPoint(x: 0.07, y: 1.14))
        path.addLine(to: CGPoint(x: 4.45, y: 5.75))
        path.addCurve(to: CGPoint(x: 5, y: 6), controlPoint1: CGPoint(x: 4.62, y: 5.92), controlPoint2: CGPoint(x: 4.8, y: 6))
        path.close()
        context.saveGState()
        context.translateBy(x: 3, y: 5.5)
        color.setFill()
        path.fill()
        context.restoreGState()
        
        context.restoreGState()
    }
    
    
    //MARK: - Canvas Images
    
    /// Symbols
    
    class func imageOfSliderHorizontal(color: UIColor) -> UIImage {
        struct LocalCache {
            static var image: UIImage!
        }
        if LocalCache.image != nil {
            return LocalCache.image
        }
        var image: UIImage
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 16, height: 16), false, 0)
        IconKit.drawSliderHorizontal(color: color)
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        LocalCache.image = image
        return image
    }
    
    class func imageOfChevronDown(color: UIColor) -> UIImage {
        struct LocalCache {
            static var image: UIImage!
        }
        if LocalCache.image != nil {
            return LocalCache.image
        }
        var image: UIImage
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 16, height: 16), false, 0)
        IconKit.drawChevronDown(color: color)
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        LocalCache.image = image
        return image
    }
    
    
    //MARK: - Resizing Behavior
    
    enum ResizingBehavior {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.
        
        func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }
            
            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)
            
            switch self {
                case .aspectFit:
                    scales.width = min(scales.width, scales.height)
                    scales.height = scales.width
                case .aspectFill:
                    scales.width = max(scales.width, scales.height)
                    scales.height = scales.width
                case .stretch:
                    break
                case .center:
                    scales.width = 1
                    scales.height = 1
            }
            
            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
    
    
}
