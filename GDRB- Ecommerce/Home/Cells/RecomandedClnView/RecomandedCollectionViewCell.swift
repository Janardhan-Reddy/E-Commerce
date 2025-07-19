//
//  RecomandedCollectionViewCell.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 30/06/25.
//

import UIKit

class RecomandedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var ProductImage: UIImageView!
    @IBOutlet weak var Productname: UILabel!
    @IBOutlet weak var offerPercentage: UILabel!
    @IBOutlet weak var finalPrice: UILabel!
    @IBOutlet weak var originalSlashedPrice: UILabel!
    @IBOutlet weak var lastBoughtCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

