//
//  UIView+Extension.swift
//  TestWeatherApp
//
//  Created by Егор Ершов on 19.05.2025.
//

import UIKit

extension UIView {
    
    enum GradientDirection {
        case leftToRight
        case topLeftToBottomRight
        case topToBottom
        case topRightToBottomLeft
        
        var startPoint: CGPoint {
            switch self {
            case .leftToRight:
                return CGPoint(x: 0, y: 0.5)
            case .topLeftToBottomRight:
                return CGPoint(x: 0, y: 0)
            case .topToBottom:
                return CGPoint(x: 0.5, y: 0)
            case .topRightToBottomLeft:
                return CGPoint(x: 1, y: 0)
            }
        }
        var endPoint: CGPoint {
            switch self {
            case .leftToRight:
                return CGPoint(x: 1, y: 0.5)
            case .topLeftToBottomRight:
                return CGPoint(x: 1, y: 1)
            case .topToBottom:
                return CGPoint(x: 0.5, y: 1)
            case .topRightToBottomLeft:
                return CGPoint(x: 0, y: 1)
            }
        }
    }
    
    func createGradient(with direction: GradientDirection, and colors: [CGColor]) {
        let layer = CAGradientLayer()
        layer.colors = colors
        layer.startPoint = direction.startPoint
        layer.endPoint = direction.endPoint
        layer.frame = self.bounds
        
        self.layer.insertSublayer(layer, at: 0)
    }
    
    func createBlurEffect(with style: UIBlurEffect.Style) {
        let effect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: effect)
        blurView.frame = self.bounds
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(blurView)
    }
}
