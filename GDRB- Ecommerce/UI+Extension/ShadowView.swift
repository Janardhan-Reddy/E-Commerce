//
//  ShadowView.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 19/07/25.
//

import UIKit
import IQKeyboardManager

class ShadowView: IQPreviousNextView {
    
    override var bounds: CGRect { didSet { setupShadow() } }
    
    func setupShadow() {
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = false
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 15
        
        self.layer.shadowPath = nil
        self.layer.shouldRasterize = false
    }
}


