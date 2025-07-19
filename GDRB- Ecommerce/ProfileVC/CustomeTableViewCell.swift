//
//  CustomeTableViewCell.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 29/11/22.
//

import UIKit

class CustomeTableViewCell: UITableViewCell {
    //custome UIImageView&UILabel
    @IBOutlet weak var ProfileIcon:UIImageView!
    @IBOutlet weak var ProfileLabel:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}

    


