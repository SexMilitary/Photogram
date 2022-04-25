//
//  UIView+Extension.swift
//  Photogramm
//
//  Created by Максим Чикинов on 04.04.2022.
//

import UIKit

extension UIView {
    
    func fadeIn(duration: Double, andDelay delay: Double = 0, completion: (() -> Void)? = nil) {
        self.fade(fromAlpha: 0, toAlpha: 1, duration: duration, andDelay: delay, completion: completion)
    }
    
    func fadeOut(duration: Double, andDelay delay: Double = 0, completion: (() -> Void)? = nil) {
        self.fade(fromAlpha: 1, toAlpha: 0, duration: duration, andDelay: delay, completion: completion)
    }
    
    func fade(fromAlpha: CGFloat, toAlpha: CGFloat, duration: Double, andDelay delay: Double = 0, completion: (() -> Void)? = nil) {
        self.alpha = fromAlpha
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: { [weak self] in
                self?.alpha = toAlpha
        }) { [weak self] _ in
            self?.alpha = toAlpha
            completion?()
        }
    }
    
    func layoutSubviewsAnimated(duration: Double = 0.3) {
        UIView.animate(withDuration: duration, animations: {
            self.layoutIfNeeded()
        })
    }
    
    func getStatusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        return statusBarHeight
    }
}

extension UIView {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.removeAnimation(forKey: "position")
        self.layer.add(animation, forKey: "position")
    }
    
    func flashing() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = .infinity
        self.layer.removeAnimation(forKey: "flash")
        self.layer.add(flash, forKey: "flash")
    }
    
    func stopFlashing() {
        self.layer.removeAnimation(forKey: "flash")
    }
}

extension UIView {
    func border(_ color: UIColor = UIColor.black.withAlphaComponent(0.05), width: CGFloat = 0.5) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
}
