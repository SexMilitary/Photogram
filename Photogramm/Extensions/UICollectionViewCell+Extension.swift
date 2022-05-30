//
//  UICollectionViewCell+Extension.swift
//  Photogramm
//
//  Created by Максим Чикинов on 05.04.2022.
//

import UIKit

extension UICollectionViewCell {
    
    func shadowDecorate(radius: CGFloat = 10, offset: CGSize = CGSize(width: 0, height: 4)) {
        contentView.layer.cornerRadius = radius
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
    
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        layer.cornerRadius = radius
    }
    
}
