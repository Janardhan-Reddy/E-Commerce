//
//  LoginController.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 10/11/22.
//

import UIKit
import IQKeyboardManager

class LoginController:UIViewController{
    //insert
    
    var queryStatement: OpaquePointer? = nil
    

    var isPasswordVisible = false
    var viewModel = RegisterViewModel()
    
    //UItextfields & UILabels & UIButtons
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var PasswordLabel: UILabel!
    @IBOutlet weak var SignButton: UIButton!
    @IBOutlet weak var ForgotButton: UIButton!
    
    
    @IBOutlet weak var signInBackgroundView: UIView!
    @IBOutlet weak var SignUpLabel: UIButton!
    //Login Button Action
    @IBAction func LoginAction(_ sender: Any) {
        
        if !(((userNameTextField.text!.count) >= 1) && ((passWordTextField.text!.count) >= 1)) {
            showAlert(message: "Please enter the valid details")
        }
        let username = userNameTextField.text ?? ""
        let password = passWordTextField.text ?? ""
        
        let loginModel = LoginDetails(email: username, password: password)
        viewModel.loginUser(login: loginModel) { [weak self] response, error in
            DispatchQueue.main.async {
                // 1) Network or server error
                
                if let error = error {
                    self?.showAlert(message: "Enter valied credentials")
                    return
                }
                
                // 2) No response?
                guard let resp = response else {
                    self?.showAlert(message: "Something went wrong. Please try again.")
                    return
                }
                
                // 3) Successful login
                if resp.status == true {
                    // Save token & login flag
                    let defaults = UserDefaults.standard
                    defaults.setValue(resp.token, forKey: "authToken")
                    defaults.setValue(true, forKey: "isLoggedIn")
                    
                    // (Optional) Save user info
                    if let user = resp.data?.user {
                        defaults.setValue(user.userID,   forKey: "userID")
                        defaults.setValue(user.name,     forKey: "userName")
                        defaults.setValue(user.email,    forKey: "userEmail")
                        defaults.setValue(user.userRole, forKey: "userRole")
                    }
                    
                    // Navigate to Home
                    if let homeVC = self?.storyboard?.instantiateViewController(withIdentifier: "Tabbar") {
                        UserDefaults.standard.set(true, forKey: "isLogin")
                        
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let sceneDelegate = windowScene.delegate as? SceneDelegate,
                           let window = sceneDelegate.window {
                            
                            window.rootViewController = homeVC
                            window.makeKeyAndVisible()
                            
                            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
                        }
                    }

                    
                } else {
                    // 4) Login failed – show whatever message the server gave us
                    let serverMessage = resp.message ?? "Login failed. Please try again."
                    self?.showAlert(message: serverMessage)
                }
            }
        }
            
    }
   
    
    
    
    @IBOutlet weak var login: UIButton!
    
    //Sign button Ation
    @IBAction func Sign(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let RegistrationController = storyboard.instantiateViewController(identifier: "RegistrationController") as RegistrationController
        // push Navigation Controller
        self.navigationController?.pushViewController(RegistrationController, animated: true)
        
    }
    //Forgot Button Action
    @IBAction func Forgot(_ sender: Any) {
        if ForgotButton.isTouchInside {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
    
    //assigning a variables to classes
    var users:[LoginUsers] = []
  
    
    override func viewDidLoad() {
        //insert login Data
       
        self.userNameTextField.text = "gdrbuser@gmail.com"
        self.passWordTextField.text = "gdrbuser"
        self.navigationItem.setHidesBackButton(true, animated: false)
        makeTextFieldCircular(textField: userNameTextField)
        makeTextFieldCircular(textField: passWordTextField)
        makeButtonCircular(button: login)
        addLeftPadding(to: userNameTextField, padding: 15)
        addLeftPadding(to: passWordTextField, padding: 15)
        setupPasswordTextField()
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
    
    func setupPasswordTextField() {
        // Create a UIButton for the eye icon
        let eyeButton = UIButton(type: .custom)
        eyeButton.tintColor = .gray
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        eyeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
      
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        
    
        passWordTextField.rightView = eyeButton
        passWordTextField.rightViewMode = .always
        passWordTextField.isSecureTextEntry = true
    }

    
    @objc func togglePasswordVisibility() {
        // Toggle the secure text entry
        isPasswordVisible.toggle()
        
        if isPasswordVisible {
            passWordTextField.isSecureTextEntry = false
            
            if let eyeButton = passWordTextField.rightView?.subviews.first as? UIButton {
                eyeButton.setImage(UIImage(systemName:  "eye"), for: .normal)  // Open eye icon
            }
        } else {
            passWordTextField.isSecureTextEntry = true
            
            if let eyeButton = passWordTextField.rightView?.subviews.first as? UIButton {
                eyeButton.setImage(UIImage(systemName:  "eye.slash"), for: .normal)  // Closed eye icon
            }
        }
    }
    
    func showAlert(message: String) {
      let alert = UIAlertController(
        title: "Validation Error",
        message: message,
        preferredStyle: .alert
      )
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async{
            self.present(alert, animated: true, completion: nil)
        }
    }

    
    
}

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

