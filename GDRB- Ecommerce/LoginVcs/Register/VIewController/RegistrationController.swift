//
//  RegistrationController.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 10/11/22.
//

import UIKit
class RegistrationController:UIViewController,UITextFieldDelegate{
    
    
    let viewModel = RegisterViewModel()
    var regResponse : RegisterationResponse?
    var isPasswordVisible = false
    //UILabels
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var PasswordLabel: UILabel!
    @IBOutlet weak var ConfirmationLabel: UILabel!
    
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var mobileNumberTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var confirmPasswordTxtField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBAction func registerButtonAction(_ sender: Any) {
        
        guard  ((nameTxtField.text!.count) >= 1)else {
            showAlert(title: "Name Empty", message: "Please enter name")
            return
        }
        let email = isValidEmail(emailTxtField.text!)
        if email == false{
            showAlert(title: "Invalid Email", message: "This is not a valid email. please try again")
            return
        }
        
        if passwordTxtField.text! != confirmPasswordTxtField.text!{
            showAlert(title: "Passwords Don't match", message: "Confirm password don't match" )
            return
        }
        if mobileNumberTxtField.text!.count != 10{
            showAlert(title: "Invalid Mobile Number", message: "Enter valied Mobile number")
            return
        }
        
        proceedToregister()
        
    }
    
    @IBAction func siginin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func proceedToregister(){
        LoadingView.shared.show()
        let name = (nameTxtField.text ?? "")
        let emailId =  emailTxtField.text ?? ""
        let password = passwordTxtField.text ?? ""
        let phone = mobileNumberTxtField.text ?? ""
        let registerModel = RegistrationDetails(name: name, email: emailId,password: password, confirmPassword: password, phoneNumber: phone )
        
        viewModel.registerUser(registeration: registerModel) { regResponse, error in
            guard error == nil else{
                self.showAlert(title: "Error", message: error?.localizedDescription ?? "")
                return
            }
            
            if let emailError = self.regResponse?.errors?.email{
                self.showAlert(title: "Error", message: emailError.first ?? "")
            }
            
            if regResponse?.status == true{
                self.showAlert(title: "Success", message: regResponse?.message ?? "")
            }
            
            self.regResponse = regResponse
            LoadingView.shared.hide()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let mobiletextFieldText = mobileNumberTxtField.text,
              let rangeOfTextToReplace = Range(range, in: mobiletextFieldText) else {
            return false
        }
        let substringToReplace = mobiletextFieldText[rangeOfTextToReplace]
        let count = mobiletextFieldText.count - substringToReplace.count + string.count
        return count <= 10
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailReg)
        return emailPred.evaluate(with: email)
    }
    
    
    override func viewDidLoad() {
        self.title = "Sign Up"
        mobileNumberTxtField.delegate = self
        
        [nameTxtField, mobileNumberTxtField,
         emailTxtField,passwordTxtField,
         confirmPasswordTxtField].forEach { textfield in
            makeTextFieldCircular(textField: textfield)
            addLeftPadding(to: textfield, padding: 15)
        }
        makeButtonCircular(button: registerButton)
        setupPasswordTextField(textField: passwordTxtField)
        setupPasswordTextField(textField: confirmPasswordTxtField)
        
    }
    
    func setupPasswordTextField(textField: UITextField) {
        // Create a UIButton for the eye icon
        let eyeButton = UIButton(type: .custom)
        eyeButton.tintColor = .gray
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        eyeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        textField.rightView = eyeButton
        textField.rightViewMode = .always
        textField.isSecureTextEntry = true
    }
    
    
    func makeTextFieldCircular(textField: UITextField) {
        textField.layer.cornerRadius = textField.frame.size.height / 2  // Circular shape
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.gray.cgColor  // Border color (adjust as needed)
        textField.clipsToBounds = true
    }
    func addLeftPadding(to textField: UITextField, padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    func makeButtonCircular(button: UIButton) {
        button.layer.cornerRadius = button.frame.size.height / 2  // Circular shape
        button.layer.borderWidth = 0
        button.layer.borderColor = UIColor.gray.cgColor  // Border color (adjust as needed)
        button.clipsToBounds = true
    }
}
