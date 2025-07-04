//
//  SavedAddress.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 06/12/22.
//

import UIKit
class SavedAddress:UIViewController,UITableViewDelegate,UITableViewDataSource{
   
    var insertDetails = AddressDtaBase()
    var data:[AddressDetails] = []
    
    @objc func SaveAction() {
        let DeliveryAddress = self.storyboard!.instantiateViewController(identifier: "DeliveryAddress") as DeliveryAddress
        self.navigationController?.pushViewController(DeliveryAddress, animated: true)
        
    }
    
    
    //tableView delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedAddressCell",for: indexPath) as! SavedAddressTableViewCell
        
        cell.NameLabel.text = data[indexPath.row].name
        cell.AddressLabel.text = data[indexPath.row].address
        cell.NumberLabel.text = data[indexPath.row].phoneNumber
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    //DeleteButtonAction
    @IBAction func DeleteAction(_ sender: Any) {
        
        
        let myMessage = "This is an alert"
        let myAlert = UIAlertController(title: myMessage, message: nil, preferredStyle: UIAlertController.Style.alert)
        
        myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
    }
    
    
    //UITableView
    @IBOutlet weak var SavedAddressTableView: UITableView!
    override func viewDidAppear(_ animated: Bool) {
        data = insertDetails.retrieveAddressDetails()
        SavedAddressTableView.reloadData()
    }
    override func viewDidLoad() {
        let plusImage = UIImage(systemName: "plus") // Create a system symbol image with the plus sign icon
        let CashDairy = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(SaveAction))
        navigationItem.rightBarButtonItem = CashDairy

        for i in data {
            print(i.phoneNumber)
            print(i.name)
            print(i.email)
            print(i.address)
            //UIBarButtonItem
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(SaveAction))
          
        }
    }
}
