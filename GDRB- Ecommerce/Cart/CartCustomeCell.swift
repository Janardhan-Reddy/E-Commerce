//
//  CartCustomeCell.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 28/11/22.
//

import UIKit

class CartCustomeCell: UITableViewCell {
    //UIImageView&UILabel&UIButton
    var deleteAction : ((Int) -> Void)?
 
    @IBOutlet weak var CartImage:UIImageView!
    @IBOutlet weak var CartProductLabel:UILabel!
    @IBOutlet weak var CartPriceLabel:UILabel!
    @IBOutlet weak var CartDeleteButton:UIButton!
    
    
    @IBAction func CartDelete(_ sender: Any) {
        if let tag = CartDeleteButton.tag as Int? {
            deleteAction?(tag)
        }
         
    }
    
    
}






