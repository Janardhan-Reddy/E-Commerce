//
//  OTPVC.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 27/06/25.
//

import UIKit


class OTPViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var otptextFields: [UITextField]!
    
    
    @IBOutlet weak var submitButton: UIButton!
    
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        let otpString = getOTPValue()
        
        if otpString?.count ?? 0 < 4 {
            showAlert(title: "OTP incomplete", message: "OTP is incomplete")
            return
        }
        
        if let otpValue =  otpString, let otpNum = Int(otpValue) {
            print("OTP entered as Int: \(otpNum)")
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "ResetPasswordVC") as? ResetPasswordVC else {return}
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            showAlert(title: "Invalid Otp", message: "OTP is invalid")
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Sort text fields by tag if not already in order
        
        makeButtonCircular(button: submitButton)
        otptextFields = otptextFields.sorted { $0.tag < $1.tag }

        for textField in otptextFields {
            textField.delegate = self
            textField.keyboardType = .numberPad
            textField.textAlignment = .center
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }

        otptextFields.first?.becomeFirstResponder()
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }

        if text.count > 1 {
            textField.text = String(text.prefix(1))
        }

        if text.count == 1 {
            // Move to next field
            if let currentIndex = otptextFields.firstIndex(of: textField),
               currentIndex < otptextFields.count - 1 {
                otptextFields[currentIndex + 1].becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        }
    }

    // MARK: Detect backspace using strcmp (your method)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        // Use strcmp to detect backspace
        if let char = string.cString(using: .utf8) {
            let isBackSpace = strcmp(char, "\\b")

            // If backspace is detected
            if isBackSpace == -92 || string.isEmpty {
             
                    if let currentIndex = otptextFields.firstIndex(of: textField), currentIndex > 0 {
                        
                        let previousField = otptextFields[currentIndex - 1]
                        let currentField = otptextFields[currentIndex]
                        currentField.text = ""
                        previousField.becomeFirstResponder()
                    }else{
                        let currentField = otptextFields[0]
                        currentField.text = ""
                        currentField.becomeFirstResponder()
                    }

                return false
            }
        }

        // Allow only 1 digit
        return range.location == 0 && CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
    }
    
    func makeButtonCircular(button: UIButton) {
        button.layer.cornerRadius = button.frame.size.height / 2  // Circular shape
        button.layer.borderWidth = 0
        button.layer.borderColor = UIColor.gray.cgColor  // Border color (adjust as needed)
        button.clipsToBounds = true
    }
    
    func getOTPValue() -> String? {
        let otpString = otptextFields
            .sorted { $0.tag < $1.tag } // Ensure correct order
            .compactMap { $0.text }
            .joined()
        
        return otpString
    }
    
    
}



class CircularView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCircularStyle()
    }
    
    private func setupCircularStyle() {
        self.layer.cornerRadius = self.bounds.width / 2
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor  = UIColor.black.cgColor
        
    }
}



class CircularImageView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCircularStyle()
    }
    
    private func setupCircularStyle() {
        self.layer.cornerRadius = self.bounds.width / 2
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0
    
    }
}


