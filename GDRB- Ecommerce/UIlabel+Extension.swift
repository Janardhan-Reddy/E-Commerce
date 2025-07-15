//
//  UIlabel+Extension.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 15/07/25.
//

import Foundation
import UIKit

extension UILabel {
    
    /// Applies strikethrough style to a single price
    func setStrikethroughPrice(_ price: String, color: UIColor = .lightGray) {
        let attributedText = NSAttributedString(
            string: price,
            attributes: [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: color
            ]
        )
        self.attributedText = attributedText
    }
    
    /// Displays original price with strikethrough followed by discounted price
//    func setStrikethroughWithDiscount(originalPrice: String,
//                                      discountedPrice: String,
//                                      originalColor: UIColor = .gray,
//                                      discountedColor: UIColor = .systemGreen,
//                                      discountedFont: UIFont? = nil) {
//        let originalAttr = NSAttributedString(
//            string: originalPrice + " ",
//            attributes: [
//                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
//                .foregroundColor: originalColor
//            ]
//        )
//        
//        let discountedAttr = NSAttributedString(
//            string: discountedPrice,
//            attributes: [
//                .foregroundColor: discountedColor,
//                .font: discountedFont ?? self.font ?? UIFont.systemFont(ofSize: 14)
//            ]
//        )
//        
//        let combined = NSMutableAttributedString()
//        combined.append(originalAttr)
//        combined.append(discountedAttr)
//        
//        self.attributedText = combined
//    }
}

