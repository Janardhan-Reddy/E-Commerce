////
////  RectangularShadowView.swift
////  GDRB- Ecommerce
////
////  Created by Pravin Kumar on 30/06/25.
////
//
//
//class RectangularShadowView: UIView {
//
//    override var bounds: CGRect {
//        didSet {
//            setupShadow()
//        }
//    }
//
//    private func setupShadow() {
//        layer.cornerRadius = 0
//        layer.masksToBounds = false
//
//        // Optional border
//        layer.borderWidth = 0.5
//        layer.borderColor = UIColor.lightGray.cgColor
//
//        // Shadow properties
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOpacity = 0.25
//        layer.shadowOffset = CGSize(width: 0, height: 6)
//        layer.shadowRadius = 10
//
//        // Create a shadow path that extends mostly downward
//        let shadowInset: CGFloat = -20  // Negative inset expands the rect
//        let shadowRect = bounds.insetBy(dx: -4, dy: shadowInset).offsetBy(dx: 0, dy: 6)
//        layer.shadowPath = UIBezierPath(roundedRect: shadowRect, cornerRadius: 0).cgPath
//
//        // Improve performance
//        layer.shouldRasterize = true
//        layer.rasterizationScale = UIScreen.main.scale
//    }
//}
