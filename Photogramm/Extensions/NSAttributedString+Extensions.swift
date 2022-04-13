//
//  NSAttributedString+Extensions.swift
//  Photogramm
//
//  Created by Максим Чикинов on 14.04.2022.
//

import UIKit

extension String {
    static func createAttributedString(firstString: String,
                                       secondString: String,
                                       firstTextColor: UIColor = .black,
                                       secondTextColor: UIColor = .black,
                                       firstFont: UIFont = .systemFont(ofSize: 18, weight: .regular),
                                       secondFont: UIFont = .systemFont(ofSize: 18, weight: .semibold)) -> NSMutableAttributedString {
        
        let firstAttribute = [NSAttributedString.Key.font : firstFont,
                              NSAttributedString.Key.foregroundColor: firstTextColor
        ]
        let secondAttribute = [NSAttributedString.Key.font : secondFont,
                               NSAttributedString.Key.foregroundColor: secondTextColor
        ]
        let resultString: String = "\(firstString) \(secondString)"
        let firstRange = (resultString as NSString).range(of: firstString)
        let secondRange = (resultString as NSString).range(of: secondString)
        let attributedString = NSMutableAttributedString(string: resultString)
        attributedString.setAttributes(firstAttribute, range: firstRange)
        attributedString.setAttributes(secondAttribute, range: secondRange)
        
        return attributedString
    }
}
