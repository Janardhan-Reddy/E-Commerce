//
//  SavedAddressTableViewCell.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 06/12/22.
//

import UIKit

class SavedAddressTableViewCell: UITableViewCell {
    var onEditButtonPress : ((Int?)->())?
    
    //UILabel&UIButton
    @IBOutlet weak var NameLabel:UILabel!
    @IBOutlet weak var AddressLabel:UILabel!
    @IBOutlet weak var NumberLabel:UILabel!
    @IBOutlet weak var AddressEditButton:UIButton!
    
    @IBAction func onEditButtonPress(_ sender: UIButton) {
        onEditButtonPress?(sender.tag)
    }
    
    
}
