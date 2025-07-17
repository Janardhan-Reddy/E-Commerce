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
        if isEdit, let existingAddress = savedAddresses {
            // Update existing address
            existingAddress.fullName = FullNameField.text
            existingAddress.phoneNumber = Int64(PhoneNumberField.text ?? "") ?? 0
            existingAddress.pincode = Int64(PincodeField.text ?? "") ?? 0
            existingAddress.state = StateField.text
            existingAddress.city = CityField.text
            existingAddress.localAddress = localityField.text
            existingAddress.flatNumber = flatNumberField.text
            existingAddress.landmark = landmarkFileld.text

            print("✅ Address updated.")
        } else {
            // Add new address
            let context = DatabaseHandler.context
            let newAddress = Address(context: context)
            newAddress.fullName = FullNameField.text
            newAddress.phoneNumber = Int64(PhoneNumberField.text ?? "") ?? 0
            newAddress.pincode = Int64(PincodeField.text ?? "") ?? 0
            newAddress.state = StateField.text
            newAddress.city = CityField.text
            newAddress.localAddress = localityField.text
            newAddress.flatNumber = flatNumberField.text
            newAddress.landmark = landmarkFileld.text

            print("✅ New address saved.")
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
}
