//
//  SavedAddress.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 06/12/22.
//

import UIKit

protocol AddressSelectionHandler: AnyObject{
    func onAddressCellSelected(_ address: Address)
}

class SavedAddress:UIViewController,UITableViewDelegate,UITableViewDataSource{
    var savedAddresses: [Address] = []

    //UITableView
    @IBOutlet weak var SavedAddressTableView: UITableView!
    
    
    weak var delegate : AddressSelectionHandler?
    
    override func viewWillAppear(_ animated: Bool) {
      
        let addresses: [Address] = DatabaseHandler.shared.fetchEntities(ofType: Address.self)
        savedAddresses = addresses
          
           SavedAddressTableView.reloadData()
    }
    override func viewDidLoad() {
        let plusImage = UIImage(systemName: "plus") // Create a system symbol image with the plus sign icon
        let CashDairy = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(SaveAction))
        navigationItem.rightBarButtonItem = CashDairy
        self.setCustomTitle(withImage: "house.circle", withTitle: "Saved Address")
        SavedAddressTableView.delegate = self
        SavedAddressTableView.register(NoRecordCell.self, forCellReuseIdentifier: "NoRecordCell")
        SavedAddressTableView.dataSource = self
    }
    
    
    
      @objc func SaveAction() {
          let DeliveryAddress = self.storyboard!.instantiateViewController(identifier: "DeliveryAddress") as DeliveryAddress
          self.navigationController?.pushViewController(DeliveryAddress, animated: true)
          
      }
      
      
      //tableView delegate methods
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return savedAddresses.isEmpty ? 1 : savedAddresses.count

      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
          if savedAddresses.isEmpty {
              let cell = tableView.dequeueReusableCell(withIdentifier: "NoRecordCell", for: indexPath) as! NoRecordCell
              return cell
          }

          
          let cell = tableView.dequeueReusableCell(withIdentifier: "SavedAddressCell", for: indexPath) as! SavedAddressTableViewCell
              
              let address = savedAddresses[indexPath.row]
              
          cell.NameLabel.text = address.fullName?.capitalized
              cell.AddressLabel.text = [
                  address.flatNumber,
                  address.localAddress?.capitalized,
                  address.landmark?.capitalized,
                  address.city?.capitalized,
                  address.state?.capitalized,
                  "India - \(address.pincode)"
              ]
              .compactMap { $0 }
              .joined(separator: ", ")
              
              cell.NumberLabel.text = String(address.phoneNumber)
          cell.AddressEditButton.tag = indexPath.row
          cell.onEditButtonPress = { tag in
              let vc = self.storyboard!.instantiateViewController(identifier: "DeliveryAddress") as DeliveryAddress
              vc.isEdit = true
              vc.savedAddresses = address
              self.navigationController?.pushViewController(vc, animated: true)
              
          }
              return cell
      }
     
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          guard !savedAddresses.isEmpty else {return}
          let selectedAddress = savedAddresses[indexPath.row]
          delegate?.onAddressCellSelected(selectedAddress)
          self.navigationController?.popViewController(animated: true)
          
      }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
          
            
            // Show confirmation alert (optional)
            let alert = UIAlertController(
                title: "Delete",
                message: "Are you sure you want to delete this item?",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
                let addressToDelete = self.savedAddresses[indexPath.row]
                let context = DatabaseHandler.context
                   context.delete(addressToDelete)
                   DatabaseHandler.saveContext()
                
                let addresses: [Address] = DatabaseHandler.shared.fetchEntities(ofType: Address.self)
                self.savedAddresses = addresses
                
              
                  
                self.SavedAddressTableView.reloadData()
                
                   print("🗑️ Address deleted.")
                completionHandler(true)
            })
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                completionHandler(false)
            })
            
            self.present(alert, animated: true)
        }
        
        deleteAction.backgroundColor = UIColor.systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
    
}
