//
//  FontHelper.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 16/07/25.
//
//
//import UIKit
//
//protocol FontApplicable {
//    func setFont(name: String, size: CGFloat)
//}
//
//extension FontApplicable where Self: UIView {
//    func setFont(name: String, size: CGFloat) {
//        if let textField = self as? UITextField {
//            textField.font = UIFont(name: name, size: size)
//        } else if let label = self as? UILabel {
//            label.font = UIFont(name: name, size: size)
//        } else if let button = self as? UIButton {
//            button.titleLabel?.font = UIFont(name: name, size: size)
//        }
//    }
//}
//
//// Common extension for UITextField, UILabel, and UIButton
//extension UITextField: FontApplicable {}
//extension UILabel: FontApplicable {}
//extension UIButton: FontApplicable {}
//
//extension UIView {
//    @IBInspectable
//    var AmzBold: CGFloat {
//        set {
//            (self as? FontApplicable)?.setFont(name: "AmazonEmber-Bold", size: newValue)
//        }
//        get {
//            return 0.0
//        }
//    }
//
//    @IBInspectable
//    var AmzonLight: CGFloat {
//        set {
//            (self as? FontApplicable)?.setFont(name: "AmazonEmber-Light", size: newValue)
//        }
//        get {
//            return 0.0
//        }
//    }
//
//    @IBInspectable
//    var AmzMedium: CGFloat {
//        set {
//            (self as? FontApplicable)?.setFont(name: "AmazonEmber-Medium", size: newValue)
//        }
//        get {
//            return 0.0
//        }
//    }
//
//    @IBInspectable
//    var AmzRegular: CGFloat {
//        set {
//            (self as? FontApplicable)?.setFont(name: "AmazonEmber-Regular", size: newValue)
//        }
//        get {
//            return 0.0
//        }
//    }
//
//    @IBInspectable
//    var AmzSemiBold: CGFloat {
//        set {
//            (self as? FontApplicable)?.setFont(name: "AmazonEmber-SemiBold", size: newValue)
//        }
//        get {
//            return 0.0
//        }
//    }
//}
