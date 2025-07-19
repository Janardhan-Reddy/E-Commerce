//
//  LoginController.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 10/11/22.
//

import UIKit

class LoginController:UIViewController{
    
    var isPasswordVisible = false
    var viewModel = LoginViewModel()
        
    
    //UItextfields & UILabels & UIButtons
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var PasswordLabel: UILabel!
    
    @IBOutlet weak var SignButton: UIButton!
    @IBOutlet weak var ForgotButton: UIButton!
    @IBOutlet weak var signInBackgroundView: UIView!
    @IBOutlet weak var SignUpLabel: UIButton!
    @IBOutlet weak var login: UIButton!

    
    //Login Button Action
    @IBAction func LoginAction(_ sender: Any) {
        
        if !(((userNameTextField.text!.count) >= 1) && ((passWordTextField.text!.count) >= 1)) {
            showAlert(title: "Invalid details", message: "Please enter the valid details")
        }
        let username = userNameTextField.text ?? ""
        let password = passWordTextField.text ?? ""
        proceedToLogin(userName: username, password: password)
    }
    
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
    
    // MARK: View Lifecycle
    
    
    
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
    
    // MARK: Private methods
    
    
    private func proceedToLogin(userName: String, password: String){
        
        let loginModel = LoginDetails(email: userName, password: password)
        viewModel.loginUser(login: loginModel) { [weak self] response, error in
            DispatchQueue.main.async {
                // 1) Network or server error
                
                if let error = error {
                    self?.showAlert(title: "Error", message: "Enter valied credentials")
                    return
                }
                // 2) No response?
                guard let resp = response else {
                    self?.showAlert(title: "Error", message: "Something went wrong. Please try again.")
                    return
                }
                
                // 3) Successful login
                if resp.status == true {
                    // Save token & login flag
                    self?.saveDetails(response: resp)
                    // Navigate to Home
                    self?.navigateToHomeTab()
                } else {
                    // 4) Login failed – show whatever message the server gave us
                    let serverMessage = resp.message ?? "Login failed. Please try again."
                    self?.showAlert(title: "Error", message: serverMessage)
                }
            }
        }
    }
    
    private func saveDetails(response: LoginResponse){
        let defaults = UserDefaults.standard
        defaults.setValue(response.token, forKey: "authToken")
        defaults.setValue(true, forKey: "isLoggedIn")
        
        // (Optional) Save user info
        if let user = response.data?.user {
            defaults.setValue(user.userID,   forKey: "userID")
            defaults.setValue(user.name,     forKey: "userName")
            defaults.setValue(user.email,    forKey: "userEmail")
            defaults.setValue(user.userRole, forKey: "userRole")
        }
    }
    
    private func navigateToHomeTab(){
        if let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar") {
            UserDefaults.standard.set(true, forKey: "isLogin")
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate,
               let window = sceneDelegate.window {
                
                window.rootViewController = homeVC
                window.makeKeyAndVisible()
                
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
            }
        }
    }

    
}
// MARK: UI
extension LoginController{
    
    func makeTextFieldCircular(textField: UITextField) {
        textField.layer.cornerRadius = textField.frame.size.height / 2  // Circular shape
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.clipsToBounds = true
    }
    
    // Function to make UIButton circular with border
    func makeButtonCircular(button: UIButton) {
        button.layer.cornerRadius = button.frame.size.height / 2
        button.layer.borderWidth = 0
        button.layer.borderColor = UIColor.gray.cgColor
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
    
}
