//
//  TextfieldSidePlaceholder.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 16/07/25.
//

import UIKit

private var ActionKey: UInt8 = 0

extension UITextField {
    
    // Closure type for the tap action
    typealias ImageTapAction = () -> Void
    
    // Store the action using associated objects
    private var rightImageTapAction: ImageTapAction? {
        get {
            return objc_getAssociatedObject(self, &ActionKey) as? ImageTapAction
        }
        set {
            objc_setAssociatedObject(self, &ActionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func addRightImageTo(padding: CGFloat,
                         height: CGFloat,
                         width: CGFloat,
                         image: UIImage,
                         tintColour: UIColor,
                         onTap: @escaping () -> Void) {
        
        let size = CGSize(width: width, height: height)
        let containerWidth = size.width + padding + 8
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: containerWidth, height: size.height))
        
        let imageView = UIImageView(image: image.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = tintColour
        imageView.isUserInteractionEnabled = true
        self.rightImageTapAction = onTap
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleRightImageTap))
        imageView.addGestureRecognizer(tapGesture)
        
        // Proper X position for right side layout
        let xPosition: CGFloat = containerWidth - width - padding
        imageView.frame = CGRect(x: xPosition, y: 0, width: size.width, height: size.height)
        
        // Optional: vertically center
        imageView.center.y = containerView.bounds.midY
        
        containerView.addSubview(imageView)
        
        self.rightView = containerView
        self.rightViewMode = .always
        self.contentVerticalAlignment = .center
        
        // Set to LTR for English layout
        self.semanticContentAttribute = .forceLeftToRight
    }


    
    // Tap handler
    @objc private func handleRightImageTap() {
        rightImageTapAction?()
    }
}

