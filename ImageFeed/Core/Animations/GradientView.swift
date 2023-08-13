//
//  AnimationView.swift
//  ImageFeed
//
//  Created by Вадим Шишков on 11.08.2023.
//

import UIKit

final class GradientView: UIView {
    
    var gradientLayer: CAGradientLayer!
    
    init(frame: CGRect, cornerRadius: CGFloat = 0) {
        super.init(frame: frame)
        
        let layer = CAGradientLayer()
        layer.frame = CGRect(origin: .zero, size: frame.size)
        layer.locations = [0, 0.1, 0.3]
        layer.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.cornerRadius = cornerRadius
        self.layer.addSublayer(layer)
        gradientLayer = layer
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateGradientLayerLocations() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.duration = 2
        animation.repeatCount = .infinity
        animation.fromValue = [0, 0.1, 0.3]
        animation.toValue = [0, 0.8, 1]
        gradientLayer.add(animation, forKey: "gradient")
    }
    
    func removeAllAnimations() {
        gradientLayer.removeAllAnimations()
    }
}
