//
//  CartCustomeCell.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 28/11/22.
//

import UIKit

class CartCustomeCell: UITableViewCell {
    //UIImageView&UILabel&UIButton
    @IBOutlet weak var CartImage:UIImageView!
    @IBOutlet weak var CartProductLabel:UILabel!
    @IBOutlet weak var CartPriceLabel:UILabel!
    @IBOutlet weak var CartCategoryLabel:UILabel!
    @IBOutlet weak var CartLoveButton:UIButton!
    @IBOutlet weak var CartDeleteButton:UIButton!
    
    @IBAction func CartLove(_ sender: Any) {
        if CartLoveButton.isSelected == true {
            CartLoveButton.isSelected = false
            CartLoveButton.setImage(UIImage(named: "fav"), for: .normal)
        }
        else {
            CartLoveButton.isSelected = true
            CartLoveButton.setImage(UIImage(named: "favfill"), for: .normal)
        }
        // Remove the button's background layer color
        CartLoveButton.backgroundColor = UIColor.clear
        CartLoveButton.layer.backgroundColor = UIColor.clear.cgColor
        
            }
    
    @IBAction func CartDelete(_ sender: Any) {
        
        
       
           }
    
       
    }


    


   
