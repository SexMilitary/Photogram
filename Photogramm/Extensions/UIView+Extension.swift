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
    
}
