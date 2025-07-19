//
//  DeliveryAddress.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 06/12/22.
//
import UIKit
import UIKit

class DeliveryAddress: UIViewController {

    var isEdit = false
    var savedAddresses: Address?

    // MARK: - Outlets
    @IBOutlet weak var WorkButton: UIButton!
    @IBOutlet weak var HomeButton: UIButton!
    
    @IBOutlet weak var FullNameField: UITextField!
    @IBOutlet weak var PhoneNumberField: UITextField!
    @IBOutlet weak var PincodeField: UITextField!
    @IBOutlet weak var StateField: UITextField!
    @IBOutlet weak var CityField: UITextField!
    @IBOutlet weak var localityField: UITextField!
    @IBOutlet weak var SaveAddressButton: UIButton!
    @IBOutlet weak var flatNumberField: UITextField!
    @IBOutlet weak var landmarkFileld: UITextField!

    // MARK: - Button Actions

    @IBAction func HomeButtonAction(_ sender: Any) {
        HomeButton.isSelected.toggle()
        WorkButton.isSelected = false
        HomeButton.setImage(UIImage(systemName: HomeButton.isSelected ? "checkmark.square.fill" : "square"), for: .normal)
        WorkButton.setImage(UIImage(systemName: "square"), for: .normal)
    }

    @IBAction func WorkButtonAction(_ sender: Any) {
        WorkButton.isSelected.toggle()
        HomeButton.isSelected = false
        WorkButton.setImage(UIImage(systemName: WorkButton.isSelected ? "checkmark.square.fill" : "square"), for: .normal)
        HomeButton.setImage(UIImage(systemName: "square"), for: .normal)
    }

    @IBAction func SaveAddressAction(_ sender: Any) {
        guard validateAllFields() else { return }
           
           let address = getAddressFromFields()
           
           if isEdit, let existingAddress = savedAddresses {
               updateAddress(existingAddress, with: address)
             
           } else {
               saveNewAddress(address)
               
           }

           DatabaseHandler.saveContext()
           self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = isEdit ? "Edit Address" : "My Address"
       
        if isEdit, let address = savedAddresses {
            FullNameField.text     = address.fullName?.capitalized
            PhoneNumberField.text  = String(address.phoneNumber)
            PincodeField.text      = String(address.pincode)
            StateField.text        = address.state
            CityField.text         = address.city
            localityField.text     = address.localAddress
            flatNumberField.text   = address.flatNumber
            landmarkFileld.text    = address.landmark
        }
    }
    
    func validateAllFields() -> Bool {
       
        
        guard let phoneNumber = PhoneNumberField.text, !phoneNumber.isEmpty else {
            showAlert(message: "Phone Number is required.")
            return false
        }
        
        guard phoneNumber.count == 10,
              CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: phoneNumber)) else {
            showAlert(message: "Enter a valid 10-digit phone number.")
            return false
        }

        guard let pincode = PincodeField.text, !pincode.isEmpty else {
            showAlert(message: "Pincode is required.")
            return false
        }

        guard pincode.count == 6,
              CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: pincode)) else {
            showAlert(message: "Enter a valid 6-digit pincode.")
            return false
        }
        
        let requiredFields = [
            (FullNameField.text, "Full Name"),
            (StateField.text, "State"),
            (CityField.text, "City"),
            (localityField.text, "Locality"),
            (flatNumberField.text, "Flat/House Number"),
            (landmarkFileld.text, "Landmark")
        ]
        
        for (field, name) in requiredFields {
            if field?.isEmpty ?? true {
                showAlert(message: "\(name) is required.")
                return false
            }
        }

        return true
    }
    
    func getAddressFromFields() -> (name: String, phone: Int64, pincode: Int64, state: String, city: String, locality: String, flat: String, landmark: String) {
        return (
            name: FullNameField.text ?? "",
            phone: Int64(PhoneNumberField.text ?? "") ?? 0,
            pincode: Int64(PincodeField.text ?? "") ?? 0,
            state: StateField.text ?? "",
            city: CityField.text ?? "",
            locality: localityField.text ?? "",
            flat: flatNumberField.text ?? "",
            landmark: landmarkFileld.text ?? ""
        )
    }
    func updateAddress(_ address: Address, with data: (name: String, phone: Int64, pincode: Int64, state: String, city: String, locality: String, flat: String, landmark: String)) {
        address.fullName = data.name
        address.phoneNumber = data.phone
        address.pincode = data.pincode
        address.state = data.state
        address.city = data.city
        address.localAddress = data.locality
        address.flatNumber = data.flat
        address.landmark = data.landmark
    }

    func saveNewAddress(_ data: (name: String, phone: Int64, pincode: Int64, state: String, city: String, locality: String, flat: String, landmark: String)) {
        if let newAddress = DatabaseHandler.shared.createEntity(ofType: Address.self) {
            updateAddress(newAddress, with: data)
        }
    }


    
    func showAlert(message: String) {
      let alert = UIAlertController(
        title: "Validation Error",
        message: message,
        preferredStyle: .alert
      )
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      present(alert, animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //For mobile numer validation
        if textField == PhoneNumberField || textField == PincodeField{
            let allowedCharacters = CharacterSet(charactersIn:"+0123456789 ")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
}
