//
//  ForgotPasswordVC.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 27/06/25.
//

import UIKit
class ForgotPasswordVC: UIViewController{
    
    // MARK: IBOutlet
    
    @IBOutlet weak var mobileEmailTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: IBAction
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func backToSigninAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        makeTextFieldCircular(textField: mobileEmailTextField)
        makeButtonCircular(button: submitButton)
        addLeftPadding(to: mobileEmailTextField, padding: 15)
    }
}
// MARK: UI

extension ForgotPasswordVC{
    func makeTextFieldCircular(textField: UITextField) {
        textField.layer.cornerRadius = textField.frame.size.height / 2  // Circular shape
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.gray.cgColor  // Border color (adjust as needed)
        textField.clipsToBounds = true
    }
    
    // Function to make UIButton circular with border
    func makeButtonCircular(button: UIButton) {
        button.layer.cornerRadius = button.frame.size.height / 2  // Circular shape
        button.layer.borderWidth = 0
        button.layer.borderColor = UIColor.gray.cgColor  // Border color (adjust as needed)
        button.clipsToBounds = true
    }
    func addLeftPadding(to textField: UITextField, padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
}
