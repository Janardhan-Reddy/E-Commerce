//
//  SeasonSaleCollectionViewCell.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 30/06/25.
//

import UIKit

class SeasonSaleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var saleMainIMG: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var offerPriceText: UILabel!
    
    @IBOutlet weak var bottomCurveView: SideCurveBottomView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
    }

}
