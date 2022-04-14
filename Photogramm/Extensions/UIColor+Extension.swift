//
//  UIColor+Extension.swift
//  Photogramm
//
//  Created by Максим Чикинов on 11.04.2022.
//

import UIKit

extension UIColor {
    class var brandTurquoise: UIColor {
        return UIColor("#0baaed")
    }
    
    class var brandOrange: UIColor {
        return UIColor("#FD8A00")
    }
    
    class var brandOrangeNew: UIColor {
        return UIColor("#ff8500")
    }
    
    class var brandOrangeDirty: UIColor {
        return UIColor("#995513")
    }
    
    class var brandGreen: UIColor {
        return UIColor("#52D02A")
    }
    
    class var brandGreenNew: UIColor {
        return UIColor("#00d40a")
    }
    
    class var brandLightGray: UIColor {
        return UIColor("#EFEFF4")
    }
    
    class var brandGray: UIColor {
        return UIColor("#919392")
    }
    
    class var brandBlack: UIColor {
        return UIColor("#1B1B1B")
    }
    
    class var brandBlue: UIColor {
        return UIColor("#60a8ea")
    }
}

extension UIColor {
    
    convenience init(_ hex: String, alpha: CGFloat = 1.0) {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") { cString.removeFirst() }
        
        if cString.count != 6 {
            self.init("ff0000") // return red color for wrong hex input
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: 1.0)
    }
    
}
