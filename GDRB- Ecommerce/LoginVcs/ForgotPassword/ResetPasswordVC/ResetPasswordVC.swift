//
//  ResetPasswordVC.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 27/06/25.
//

import UIKit
class ResetPasswordVC : UIViewController{
   
    
  
    @IBOutlet weak var newPassword: UITextField!
    
    @IBOutlet weak var confirmPassword: UITextField!
    
    
    @IBOutlet weak var submitButton: UIButton!
    
    
    @IBAction func submitAction(_ sender: UIButton) {
        
        guard let newPass =  newPassword.text , let confirmPass = confirmPassword.text else {
            showAlert(title: "Enter Password", message: "Please enter text in both the fields")
            return
        }
        
        if newPass == confirmPass {
            //continue
            
            
        }else{
            showAlert(title: "Password Don't Match", message: "New Password and Confirm password don't match, Please re-enter")
            newPassword.text = nil
            confirmPassword.text = nil
            return
        }
        
        
    }
    
    @IBAction func backToSigninPress(_ sender: UIButton) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [newPassword, confirmPassword].forEach { textField in
            makeTextFieldCircular(textField: textField)
            addLeftPadding(to: textField, padding: 15)
        }
        makeButtonCircular(button: submitButton)
    }
    
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
