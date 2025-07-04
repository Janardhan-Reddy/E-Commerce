//
//  DeliveryAddress.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 06/12/22.
//
import UIKit
class DeliveryAddress:UIViewController{
    var storedEmail:String = ""
    var insertDetails = AddressDtaBase()
    var addressData:[AddressDetails] = []
  
    @IBOutlet weak var WorkButton: UIButton!
    
    @IBOutlet weak var HomeButton: UIButton!
    
    @IBAction func HomeButtonAction(_ sender: Any) {
        if HomeButton.isSelected == true {
            HomeButton.isSelected = false
            HomeButton.setImage(UIImage(systemName: "square"), for: .normal)
        }
        else {
            HomeButton.isSelected = true
            WorkButton.isSelected = false
            HomeButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            WorkButton.setImage(UIImage(systemName:"square"), for: .normal)
        }
        
    }
   
    
    @IBAction func WorkButtonAction(_ sender: Any) {
        if WorkButton.isSelected == true {
           WorkButton.isSelected = false
            WorkButton.setImage(UIImage(systemName:"square"), for: .normal)
        }
        else {
            WorkButton.isSelected = true
            HomeButton.isSelected = false
            WorkButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            HomeButton.setImage(UIImage(systemName: "square"), for: .normal)
        }
        
    }
    //UITextFields&UIButton
    @IBOutlet weak var FullNameField: UITextField!
    @IBOutlet weak var PhoneNumberField: UITextField!
    @IBOutlet weak var PincodeField: UITextField!
    @IBOutlet weak var StateField: UITextField!
    @IBOutlet weak var CityField: UITextField!
    @IBOutlet weak var localityField: UITextField!
    @IBOutlet weak var SaveAddressButton: UIButton!
    @IBOutlet weak var flatNumberField: UITextField!
    @IBOutlet weak var landmarkFileld: UITextField!
    
    @IBAction func SaveAddressAction(_ sender: Any) {
        print("hchfhnd")
        let space = " " // The space separator

        let addressString = flatNumberField.text! + space + localityField.text! + space + landmarkFileld.text! + space + CityField.text! + space + StateField.text! + space + "India" + space + "-" + space + PincodeField.text!
        // Use the storedEmail value as needed
              insertDetails.insert(email: storedEmail, address: addressString, name: FullNameField.text!, phoneNumber: PhoneNumberField.text!)
            
        self.navigationController?.popViewController(animated: true)
            
        }
    
   //UITextField delegate methods
    
    override func viewDidLoad() {
        
        storedEmail =  UserDefaults.standard.string(forKey: "userEmail")!
      self.title = "My Address"
        let data = insertDetails.retrieveAddressDetails()
        for i in data {
            print(i.phoneNumber)
            print(i.name)
            print(i.email)
            print(i.address)
        }
       
      
      
       
    }
}
